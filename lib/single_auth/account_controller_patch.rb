module SingleAuth
  module AccountControllerPatch

    def self.included(base)
      base.send(:include, ClassMethods)

      base.class_eval do
        alias_method_chain :login, :ldap_single_auth
        alias_method_chain :successful_authentication, :ldap_single_auth
      end
    end

    module ClassMethods

      def login_with_ldap_single_auth
        if (User.current.logged?)
          redirect_back_or_default(home_url)
          return
        end
        login_without_ldap_single_auth
      end

      def successful_authentication_with_ldap_single_auth(user)
        logger.debug("domain=#{request.domain}")
        logger.debug("ip=#{request.remote_ip}")
        logger.debug("dsfdf=#{Setting.plugin_single_auth[:intranet_domains]}")
        enable_sms_auth = Setting.plugin_single_auth[:enable_sms_auth]
        intranet_domains = Setting.plugin_single_auth[:intranet_domains]
        ip_whitelist = Setting.plugin_single_auth[:ip_whitelist]
        user_groups_whitelist = Setting.plugin_single_auth[:user_groups_whitelist]
        if enable_sms_auth && (user.respond_to?("user_phones") && defined?(UserPhone)) && (user.groups.map{|group| group.id} & user_groups_whitelist).count == 0
          unless intranet_domains.include?(request.domain) && ip_whitelist.include?(request.remote_ip)

          else
            successful_authentication_without_ldap_single_auth(user)
          end
        else
          successful_authentication_without_ldap_single_auth(user)
        end
      end

      def generate_sms_token

      end

    end
  end
end

