module Puppet::Parser::Functions
  newfunction(:kerberos_kdc_principal_options_encode, :arity => 3, :type => :rvalue) do |args|
    randkey = args[0]
    pw      = args[1]
    options = args[2]

    string = ''

    if randkey
      string << '-randkey'
    elsif pw
      string << "-pw #{pw}"
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
