Puppet::Type.newtype(:kerberos_kdc_principal) do
  @doc = "Create a Kerberos principal in a realm, with attributes."

  ensurable

  newproperty(:name, :namevar => :true) do
    desc "The full Kerberos principal name, including target realm."
  end

  newproperty(:pw) do
    desc "The password to authenticate with the principal."
  end

  newparam(:randkey, :boolean => true, :parent => Puppet::Parameter::Boolean) do
    desc "Enable or disable the use of a random key as the password in the principal. If true, disables the 'password' attribute."
  end

  newproperty(:options) do
    desc "Optional parameters to give to the Kerberos principal."
  end
end