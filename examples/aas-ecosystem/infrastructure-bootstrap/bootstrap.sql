-- Drop the previous signature (without p_is_go_infrastructure) so re-running
-- the bootstrap on an existing database does not leave an ambiguous overload.
DROP FUNCTION IF EXISTS public.ensure_aas_infrastructure(
  text, text, text, text, text, text, text, text, text,
  boolean, boolean, boolean, boolean, text
);

CREATE OR REPLACE FUNCTION public.ensure_aas_infrastructure(
  p_organisation_name text,
  p_name text,
  p_description text DEFAULT NULL,
  p_discovery_url text DEFAULT NULL,
  p_registry_url text DEFAULT NULL,
  p_repository_url text DEFAULT NULL,
  p_submodel_registry_url text DEFAULT NULL,
  p_submodel_repository_url text DEFAULT NULL,
  p_concept_description_repository_url text DEFAULT NULL,
  p_is_internal boolean DEFAULT NULL,
  p_handle_as_internal boolean DEFAULT NULL,
  p_is_readonly boolean DEFAULT NULL,
  p_is_active boolean DEFAULT NULL,
  p_is_go_infrastructure boolean DEFAULT false,
  p_bootstrap_user text DEFAULT 'bootstrap'
)
RETURNS void
LANGUAGE plpgsql
AS $$
DECLARE
  v_org_id integer;
  v_template_payload jsonb;
  v_sequence_name text;
BEGIN
  SELECT o."Id"
  INTO v_org_id
  FROM public."Organisations" o
  WHERE o."Name" = p_organisation_name
  LIMIT 1;

  IF v_org_id IS NULL THEN
    RAISE WARNING 'Organisation "%" not found. Skipping infrastructure "%".', p_organisation_name, p_name;
    RETURN;
  END IF;

  IF EXISTS (
    SELECT 1
    FROM public."AasInfrastructureSettings" i
    WHERE i."OrganisationId" = v_org_id
      AND i."Name" = p_name
  ) THEN
    RAISE NOTICE 'Infrastructure "%" already exists in organisation "%". Skipping.', p_name, p_organisation_name;
    RETURN;
  END IF;

  SELECT to_jsonb(i) - 'Id'
  INTO v_template_payload
  FROM public."AasInfrastructureSettings" i
  WHERE i."OrganisationId" = v_org_id
  ORDER BY i."Id"
  LIMIT 1;

  IF v_template_payload IS NULL THEN
    SELECT to_jsonb(i) - 'Id'
    INTO v_template_payload
    FROM public."AasInfrastructureSettings" i
    ORDER BY i."Id"
    LIMIT 1;
  END IF;

  IF v_template_payload IS NULL THEN
    RAISE WARNING 'No template infrastructure row found. Cannot create "%".', p_name;
    RETURN;
  END IF;

  SELECT pg_get_serial_sequence('public."AasInfrastructureSettings"', 'Id')
  INTO v_sequence_name;

  INSERT INTO public."AasInfrastructureSettings"
  SELECT (rows.r).*
  FROM (
    SELECT jsonb_populate_record(
      NULL::public."AasInfrastructureSettings",
      v_template_payload || jsonb_build_object(
        'Id', nextval(v_sequence_name),
        'OrganisationId', v_org_id,
        'Name', p_name,
        'Description', COALESCE(p_description, v_template_payload->>'Description'),
        'AasDiscoveryUrl', COALESCE(p_discovery_url, v_template_payload->>'AasDiscoveryUrl'),
        'AasRegistryUrl', COALESCE(p_registry_url, v_template_payload->>'AasRegistryUrl'),
        'AasRepositoryUrl', COALESCE(p_repository_url, v_template_payload->>'AasRepositoryUrl'),
        'SubmodelRegistryUrl', COALESCE(p_submodel_registry_url, v_template_payload->>'SubmodelRegistryUrl'),
        'SubmodelRepositoryUrl', COALESCE(p_submodel_repository_url, v_template_payload->>'SubmodelRepositoryUrl'),
        'ConceptDescriptionRepositoryUrl', COALESCE(p_concept_description_repository_url, v_template_payload->>'ConceptDescriptionRepositoryUrl'),
        'IsInternal', COALESCE(p_is_internal, (v_template_payload->>'IsInternal')::boolean),
        'HandleAsInternal', COALESCE(p_handle_as_internal, (v_template_payload->>'HandleAsInternal')::boolean),
        'IsReadonly', COALESCE(p_is_readonly, (v_template_payload->>'IsReadonly')::boolean),
        'IsActive', COALESCE(p_is_active, (v_template_payload->>'IsActive')::boolean),
        'IsGoInfrastructure', p_is_go_infrastructure,
        'AnlageDatum', now(),
        'AnlageBenutzer', p_bootstrap_user,
        'AenderungsDatum', now(),
        'AenderungsBenutzer', p_bootstrap_user,
        'AenderungsZaehler', 0,
        'Geloescht', false
      )
    ) AS r
  ) rows;

  RAISE NOTICE 'Infrastructure "%" created in organisation "%".', p_name, p_organisation_name;
END;
$$;

-- Grants every organisation admin (role ORGA_ADMIN) read/write/publish rights
-- on every infrastructure of their organisation. Existing rights are kept.
CREATE OR REPLACE FUNCTION public.ensure_admin_infrastructure_rights(
  p_bootstrap_user text DEFAULT 'bootstrap'
)
RETURNS void
LANGUAGE plpgsql
AS $$
DECLARE
  v_count integer;
BEGIN
  INSERT INTO public."BenutzerInfrastrukturRechte" (
    "BenutzerId",
    "OrganisationId",
    "InfrastrukturId",
    "DarfLesen",
    "DarfSchreiben",
    "DarfMarktPublizieren",
    "AnlageDatum",
    "AnlageBenutzer",
    "AenderungsDatum",
    "AenderungsBenutzer",
    "Geloescht",
    "AenderungsZaehler"
  )
  SELECT
    bo."BenutzerId",
    i."OrganisationId",
    i."Id",
    true,
    true,
    true,
    now(),
    p_bootstrap_user,
    now(),
    p_bootstrap_user,
    false,
    0
  FROM public."AasInfrastructureSettings" i
  JOIN public."BenutzerOrganisations" bo
    ON bo."OrganisationId" = i."OrganisationId"
   AND bo."Geloescht" = false
   AND bo."BenutzerRollen" LIKE '%"ORGA_ADMIN"%'
  WHERE i."Geloescht" = false
    AND NOT EXISTS (
      SELECT 1
      FROM public."BenutzerInfrastrukturRechte" r
      WHERE r."BenutzerId" = bo."BenutzerId"
        AND r."OrganisationId" = i."OrganisationId"
        AND r."InfrastrukturId" = i."Id"
        AND r."Geloescht" = false
    );

  GET DIAGNOSTICS v_count = ROW_COUNT;
  RAISE NOTICE 'Granted % infrastructure right(s) to organisation admins.', v_count;
END;
$$;
