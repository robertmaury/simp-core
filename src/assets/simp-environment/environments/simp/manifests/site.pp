# Set the global Exec path to something reasonable
Exec {
  path => [
    '/usr/local/bin',
    '/usr/local/sbin',
    '/usr/bin',
    '/usr/sbin',
    '/bin',
    '/sbin'
  ]
}


# SIMP Scenarios
#
# Set this variable to make use of the different class sets in heiradata/scenarios,
#   mostly applicable to puppet agents, or, the SIMP server overrides some of these.
#   * `simp` - compliant and secure
#   * `simp-lite` - makes use of many of our modules, but doesn't apply
#        many prohibitive security or compliance features, svckill
#   * `poss` - only include pupmod by default to configure the agent
$simp_scenario = 'poss'

# Map SIMP parameters to NIST Special Publication 800-53, Revision 4
# See hieradata/compliance_profiles/ for more options.
$compliance_profile = 'nist_800_53_rev4'

# Place Hiera customizations based on this variable in hieradata/hostgroups/${::hostgroup}.yaml
#
# Example hostgroup declaration using a regex match on the hostname:
#   if $facts['fqdn'] =~ /ws\d+\.<domain>/ {
#     $hostgroup = 'workstations'
#   }
#   else {
#     $hostgroup = 'default'
#   }
#
$hostgroup = 'default'

# Include the simp_options class to ensure that defaults provided there can be found:
# See the docs for more info: http://www.puppetmodule.info/github/simp/pupmod-simp-simp_options/master/
include '::simp_options'

# Add Puppet classes to the `classes` array in hiera to add them to the system.
# For special cases where a class needs to be removed from the classes array, you
# can use the `class_exclusions` array and it will be subtracted.
$hiera_classes          = lookup('classes',          Array[String], 'unique', [])
$hiera_class_exclusions = lookup('class_exclusions', Array[String], 'unique', [])
$hiera_included_classes = $hiera_classes - $hiera_class_exclusions
include $hiera_included_classes
# Include the compliance class last to ensure all of parameters are available
# before the mappings are checked.
include compliance_markup
