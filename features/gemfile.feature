Feature: The Gemfile can handle a variety of platforms and ruby versions.

Given that Aruba will run on many different platforms and with many different ruby versions,
the Gemfile needs to be able to handle a wide variety of combinations of operating systems and
ruby versions.  The Gemfile will use the correct set of gems for a particular configuration.

  Scenario Outline: Unix OS and mri Ruby version 2.0
    Given The OS is <os_name>
    And The ruby distribution is <ruby_distro>
    And The ruby version is <ruby_version>
    When Bundle install has been run successfully
    And the Gemfile.lock has been parsed
    Then the parsed results have <gems>
    And the parsed results should not contain <doesnt_have_gems>

    Examples:
      | os_name | ruby_distro | ruby_version | gems                                                                                                           | doesnt_have_gems |
      | unix    | mri         | 1.8.7        | 'rake'=>'~> 10.4.2, 'simplecov'=>'~> 0.10', 'rspec'=>'~> 2.2.0', 'fuubar'=>'~> 2.0.0', 'cucumber'=>'~> 1.3.20' |  'rubysl'=>'~> 2.0', 'rubinius-developer_tools'                 |
      | unix    | mri         | 1.9.3        |                                                                                                                | 'cucumber', '~> 1.3.20', 'rubysl'=>'~> 2.0', 'rubinius-developer_tools'                 |
      | unix    | mri         | 1.9.5        |                                                                                                                | 'cucumber', '~> 1.3.20', 'rubysl'=>'~> 2.0', 'rubinius-developer_tools'                 |
      | unix    | mri         | 2.0.0        |                                                                                                                | 'cucumber', '~> 1.3.20', 'rubysl'=>'~> 2.0', 'rubinius-developer_tools'                 |
      | unix    | mri         | 2.1.0        |                                                                                                                |  'cucumber', '~> 1.3.20', 'rubysl'=>'~> 2.0', 'rubinius-developer_tools'                |
      | unix    | mri         | 2.2.2        |                                                                                                                |  'cucumber', '~> 1.3.20', 'rubysl'=>'~> 2.0', 'rubinius-developer_tools'                |
      | unix    | jruby       | 1.9.3        |                                                                                                                |   'cucumber', '~> 1.3.20', 'rubysl'=>'~> 2.0', 'rubinius-developer_tools'               |
      | unix    | jruby       | 1.9.5        |                                                                                                                |   'cucumber', '~> 1.3.20', 'rubysl'=>'~> 2.0', 'rubinius-developer_tools'               |
      | unix    | jruby       | 2.0.0        |                                                                                                                |   'cucumber', '~> 1.3.20', 'rubysl'=>'~> 2.0', 'rubinius-developer_tools'               |
      | unix    | jruby       | 2.1.0        |                                                                                                                |   'cucumber', '~> 1.3.20', 'rubysl'=>'~> 2.0', 'rubinius-developer_tools'               |
      | unix    | jruby       | 2.2.2        |                                                                                                                |   'cucumber', '~> 1.3.20', 'rubysl'=>'~> 2.0', 'rubinius-developer_tools'               |
      | unix    | rbx         | 1.8.7        | 'rubysl'=>'~> 2.0', 'rubinius-developer_tools'                                                                 |                  |
      | unix    | rbx         | 1.9.3        | 'rubysl'=>'~> 2.0', 'rubinius-developer_tools'                                                                 |     'cucumber', '~> 1.3.20'             |
      | unix    | rbx         | 1.9.5        | 'rubysl'=>'~> 2.0', 'rubinius-developer_tools'                                                                 |  'cucumber', '~> 1.3.20'                |
      | unix    | rbx         | 2.0.0        | 'rubysl'=>'~> 2.0', 'rubinius-developer_tools'                                                                 |   'cucumber', '~> 1.3.20'               |
      | unix    | rbx         | 2.1.0        | 'rubysl'=>'~> 2.0', 'rubinius-developer_tools'                                                                 |   'cucumber', '~> 1.3.20'               |
      | unix    | rbx         | 2.2.2        | 'rubysl'=>'~> 2.0', 'rubinius-developer_tools'                                                                 |  'cucumber', '~> 1.3.20' ,               |
      | windows | mri         | 1.8.7        |                                                                                                                |  'rubysl'=>'~> 2.0', 'rubinius-developer_tools'                 |
      | windows | mri         | 1.9.3        |                                                                                                                |   'cucumber', '~> 1.3.20' , 'rubysl'=>'~> 2.0', 'rubinius-developer_tools'              |
      | windows | mri         | 1.9.5        |                                                                                                                |   'cucumber', '~> 1.3.20' , 'rubysl'=>'~> 2.0', 'rubinius-developer_tools'              |
      | windows | mri         | 2.0.0        |                                                                                                                |   'cucumber', '~> 1.3.20' , 'rubysl'=>'~> 2.0', 'rubinius-developer_tools'              |
      | windows | mri         | 2.1.0        |                                                                                                                |   'cucumber', '~> 1.3.20' , 'rubysl'=>'~> 2.0', 'rubinius-developer_tools'              |
      | windows | mri         | 2.2.2        |                                                                                                                |  'cucumber', '~> 1.3.20', 'rubysl'=>'~> 2.0', 'rubinius-developer_tools'                |
      | windows | jruby       | 1.9.3        |                                                                                                                |  'cucumber', '~> 1.3.20', 'rubysl'=>'~> 2.0', 'rubinius-developer_tools'                |
      | windows | jruby       | 1.9.5        |                                                                                                                |  'cucumber', '~> 1.3.20', 'rubysl'=>'~> 2.0', 'rubinius-developer_tools'                |
      | windows | jruby       | 2.0.0        |                                                                                                                |  'cucumber', '~> 1.3.20', 'rubysl'=>'~> 2.0', 'rubinius-developer_tools'                |
      | windows | jruby       | 2.1.0        |                                                                                                                |  'cucumber', '~> 1.3.20', 'rubysl'=>'~> 2.0', 'rubinius-developer_tools'                |
      | windows | jruby       | 2.2.2        |                                                                                                                |  'cucumber', '~> 1.3.20', 'rubysl'=>'~> 2.0', 'rubinius-developer_tools'                |
  

