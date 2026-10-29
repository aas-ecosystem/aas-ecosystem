-- Add additional infrastructures here.
-- Existing rows are matched by (Organisation.Name + Infrastructure.Name) and are not inserted twice.
--
-- Example:
-- SELECT public.ensure_aas_infrastructure(
--   p_organisation_name => 'My Organisation',
--   p_name => 'External Infrastructure',
--   p_description => 'Bootstrap seeded external infrastructure',
--   p_discovery_url => 'https://example.org/discovery',
--   p_registry_url => 'https://example.org/registry',
--   p_repository_url => 'https://example.org/aas-repository',
--   p_submodel_registry_url => 'https://example.org/submodel-registry',
--   p_submodel_repository_url => 'https://example.org/submodel-repository',
--   p_concept_description_repository_url => 'https://example.org/concept-description-repository',
--   p_is_internal => false,
--   p_handle_as_internal => false,
--   p_is_readonly => false,
--   p_is_active => true
-- );

-- Rename the suite default naming after bootstrap.
UPDATE public."AasInfrastructureSettings"
SET
  "Name" = 'Template Repository',
  "AenderungsDatum" = now(),
  "AenderungsBenutzer" = 'bootstrap',
  "AenderungsZaehler" = COALESCE("AenderungsZaehler", 0) + 1,
  "IsGoInfrastructure" = true
WHERE "Name" = 'Internal Infrastructure';

-- Remove the previously introduced extra record so only the desired 3 remain.
DELETE FROM public."AasInfrastructureSettings"
WHERE "Name" = 'External Infrastructure';

-- Default workshop seed: add exactly the two additional infrastructures.
SELECT public.ensure_aas_infrastructure(
  p_organisation_name => 'Demo Organisation',
  p_name => 'IDTA SMT Repo',
  p_description => 'IDTA SMT Repo',
  p_discovery_url => 'https://smt-repo.admin-shell-io.com/api/v3.0',
  p_registry_url => '',
  p_repository_url => 'https://smt-repo.admin-shell-io.com/api/v3.0',
  p_submodel_registry_url => '',
  p_submodel_repository_url => 'https://smt-repo.admin-shell-io.com/api/v3.0',
  p_concept_description_repository_url => 'https://smt-repo.admin-shell-io.com/api/v3.0',
  p_is_internal => false,
  p_handle_as_internal => false,
  p_is_readonly => false,
  p_is_active => true
);

SELECT public.ensure_aas_infrastructure(
  p_organisation_name => 'Demo Organisation',
  p_name => 'AAS.TE',
  p_description => 'AAS.TE',
  p_discovery_url => 'http://__LOCAL_HOSTNAME__:8090',
  p_registry_url => 'http://__LOCAL_HOSTNAME__:8090',
  p_repository_url => 'http://__LOCAL_HOSTNAME__:8090',
  p_submodel_registry_url => 'http://__LOCAL_HOSTNAME__:8090',
  p_submodel_repository_url => 'http://__LOCAL_HOSTNAME__:8090',
  p_concept_description_repository_url => 'http://__LOCAL_HOSTNAME__:8090',
  p_is_internal => false,
  p_handle_as_internal => false,
  p_is_readonly => true,
  p_is_active => true
);
-- Give every organisation admin full rights on all infrastructures above.
-- Must stay at the end of this file so newly seeded infrastructures are included.
SELECT public.ensure_admin_infrastructure_rights();
