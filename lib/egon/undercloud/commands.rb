
module Egon
  module Undercloud
    class Commands

      def self.OSP7_satellite(satellite_url, org, activation_key)
        return "
        curl -k -O #{satellite_url}/pub/katello-ca-consumer-latest.noarch.rpm
        yum install -y katello-ca-consumer-latest.noarch.rpm
        subscription-manager register --org=\"#{org}\" --activationkey=\"#{activation_key}\"
        #{OSP7_COMMON}"
      end
    
      def self.OSP7_vanilla_rhel(rhsm_user, rhsm_password, rhsm_pool_id)
        return "
        sudo subscription-manager register --force --username=\"#{rhsm_user}\" --password=\"#{rhsm_password}\"
        sudo subscription-manager attach --pool=\"#{rhsm_pool_id}\"
        sudo subscription-manager repos --enable=rhel-7-server-rpms \
         --enable=rhel-7-server-optional-rpms --enable=rhel-7-server-extras-rpms \
         --enable=rhel-7-server-openstack-6.0-rpms
        #{OSP7_COMMON}"
      end
    
      def self.OSP7_instack_virt
        return OSP7_COMMON
      end
    
      OSP7_COMMON = "
      sudo yum install -y https://rdoproject.org/repos/openstack-kilo/rdo-release-kilo.rpm
      sudo curl -o /etc/yum.repos.d/rdo-management-trunk.repo http://trunk-mgt.rdoproject.org/centos-kilo/current-passed-ci/delorean-rdo-management.repo
      sudo yum install -y python-rdomanager-oscplugin
      # TODO: answers file should come from RHCI
      cp /usr/share/instack-undercloud/instack.answers.sample ~/instack.answers;
      # TODO: for baremetal a nodes.csv file may also be required
      openstack undercloud install
      sudo cp /root/tripleo-undercloud-passwords .
      sudo chown $USER: tripleo-undercloud-passwords
      sudo cp /root/stackrc .
      sudo chown $USER: stackrc"
    end
  end  
end