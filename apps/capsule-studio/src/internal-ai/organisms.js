export const ORGANISM_VERSION = 'nova-cain-oro-organism-registry/2.0.0-alpha';

const sharedDenied = Object.freeze([
  'secret_exposure',
  'ungoverned_command_execution',
  'offensive_cyber_execution',
  'silent_external_deployment',
  'private_trunk_disclosure',
  'unreceipted_state_mutation'
]);

export const organisms = Object.freeze([
  {
    id: 'NOVA',