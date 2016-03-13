Puppet::Type.type(:kerberos_kdc_principal).provide(:kadmin) do
  desc "Resource provider for a Kerberos principal."

  defaultfor :osfamily => :debian

  commands :kadmin_local => '/usr/sbin/kadmin.local'
  commands :kdb5_util    => '/usr/sbin/kdb5_util'

  mk_resource_methods

  # Retrieve the list of realms configured on the system.
  def self.realms
    realms = []

    # TODO: find a way to not hardcode this.
    kerberos_kdc_conf_file = '/etc/krb5kdc/kdc.conf'

    if File.file?(kerberos_kdc_conf_file)
      lines = File.readlines(kerberos_kdc_conf_file)
      i     = lines.index { |line| line =~ /^[[:space:]]*\[realms\]/ } + 1

      until lines[i] =~ /^[[:space:]]*\[[a-z][a-z]*\]/
        realm = lines[i].gsub(/^[[:space:]]*([A-Za-z][A-Za-z0-9\.]*[A-Za-z]|[A-Za-z][A-Za-z]*)[[:space:]]*=[[:space:]]*{/, '\1')
        realms.push(realm) if !realm.empty?
        i += 1
      end
    end

    realms
  end

  # Provide a list of resources that this provider may/can manage.
  # In our case, list all of the principals that are present on the Kerberos KDC.
  # This is necessary for 'puppet resource' to work.
  # Unfortunately, due to the fact most Kerberos principal options CANNOT be
  # retrieved using kadmin (especially the password), self.instances will only
  # provide its ensure state.
  # TODO: consider changing to use kdb5_util, hopefully get more information that way
  def self.instances
    resources = []

    self.realms.each do |realm|
      begin
        kadmin_local('-r', realm, '-q', "list_principals").each_line do |name|
          resource = {}

          resource[:name]   = name
          resource[:ensure] = present

          resources.push(resource)
        end
      rescue Exception => e
        raise(Puppet::Error, "Command: kadmin.local -r #{realm} -q \"list_principals\"\nError message: #{e.message}")
      end
    end

    resources
  end

  # Define the @property_flush variable in the provider constructor,
  # which will be used to store resource attributes to flush.
  def initialize(value={})
    super(value)
    @property_flush = {}
  end

  # Returns true if the resource already exists.
  # Required method to make a provider ensurable.
  def exists?
    @property_hash[:ensure] == :present
  end

  # Set the intent to create the resource.
  # Required method to make a provider ensurable.
  def create
    @property_flush[:ensure] = :present
  end

  # Set the intent to destroy the resource.
  # Required method to make a provider ensurable.
  def destroy
    @property_flush[:ensure] = :absent
  end

  # Define getter and setter methods for resource attributes.
  # Necessary to explicitly set to use @property_flush.
  # Getter:
  # def pw
  #   ... get pw ...
  # end
  ##def pw=(value)
  #   @property_flush[:pw] = value
  # end

  # Helper method to encode principal options into one big string of parameters
  # that kadmin can accept.
  def options_encode(randkey, pw, options)
    string = ''

    if randkey
      string << '-randkey'
    elsif pw
      string << "-pw #{pw]}"
    else
      string << '-nokey'
    end

    options.each do |key, value|
      if value.is_a?(Boolean)
        string << value ? "+#{key}" : "-#{key}"
      elsif value.is_a?(Array)
        string << "-#{key} #{value.join(',')}"
      elsif value.kind_of?(Hash)
        v = value.map{|k, v| "#{k}=#{v}"}.join(',')
        string << "-#{key} #{v}"
      elsif value == 'defined'
        string << "-#{key}"
      elsif value
        string << "-#{key} #{value}"
      end
    end

    string
  end

  # Returns true if the principal exists in the Kerberos database.
  #def principal_exists?
  #  principal = resource[:name].gsub(/^(.*)@(.*)$/, '\1')
  #  realm     = resource[:name].gsub(/^(.*)@(.*)$/, '\2')
  #
  #  begin
  #    kadmin_local('-r', realm, '-q', "list_principals #{principal}").include?(principal)
  #  rescue Exception => e
  #    raise(Puppet::Error, "Command: kadmin.local -r #{realm} -q \"list_principals #{principal}\"\nError message: #{e.message}")
  #  end
  #end

  # Ensure the intended state of the principal provider.
  def principal_ensure
    principal = resource[:name].gsub(/^(.*)@(.*)$/, '\1')
    realm     = resource[:name].gsub(/^(.*)@(.*)$/, '\2')
    options   = options_encode(@resource[:randkey], @resource[:pw], @resource[:options])
    intent    = @property_flush[:ensure]

    begin
      # if principal_exists?
      if exists?
        if intent == :present
          kadmin_local('-r', realm, '-q', "modify_principal #{options} #{principal}")
        elsif intent == :absent
          kadmin_local('-r', realm, '-q', "delete_principal -force #{principal}")
        end
      elsif intent == :present
          kadmin_local('-r', realm, '-q', "add_principal #{options} #{principal}")
      end
    rescue Exception => e
      raise(Puppet::Error, "Realm: #{realm}\nPrincipal: #{principal}\nOptions: #{options}\nEnsure: #{intent}\nError message: #{e.message}")
    end
  end

  # Flush all changes to the resource, and set the property hash
  # to the changed values.
  def flush
    principal_ensure
    @property_hash = resource.to_hash
  end
end