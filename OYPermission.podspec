Pod::Spec.new do |s|
  s.name                      = "OYPermission"
  s.version                   = "1.0"
  s.summary                   = "Swift SDK to help with Permission authorizations"

  s.homepage                  = "github.com/osmanyildirim"
  s.license                   = { :type => "MIT", :file => "LICENSE" }
  s.author                    = { "osmanyildirim" => "github.com/osmanyildirim" }

  s.ios.deployment_target     = "11.0"
  s.swift_version             = "5.7"
  s.requires_arc              = true

  s.source                    = { git: "https://github.com/osmanyildirim/OYPermission.git", :tag => s.version }
  s.source_files              = "Sources/**/*.*"
end