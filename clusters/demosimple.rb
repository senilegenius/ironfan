ClusterChef.cluster 'demosimple' do
  cloud(:ec2) do
    flavor              't1.micro'
  end

  role                  :base_role
  role                  :chef_client
  role                  :ssh

  #
  # An NFS server to hold your home drives.
  #
  # It's stop-start'able, but if you're going to use this long-term, you should
  # consider creating a separate EBS volume to hold /home
  #
  facet :homebase do
    instances           1
    role                :nfs_server
  end

  #
  # A throwaway facet for development.
  #
  facet :sandbox do
    instances           2

    cloud do
      flavor           'm1.large'
      backing          'ebs'

      image_name          'mrflip-natty'
      bootstrap_distro    'ubuntu10.04-cluster_chef'
      chef_client_script  'client-v3.rb'
      mount_ephemerals(:tags => { :hadoop_scratch => true })

    end

    role                :nfs_client
  end

end
