# Uncomment the next line to define a global platform for your project
 platform :ios, '15.0'

target 'ChurchNotes' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ChurchNotes

pod 'FirebaseFirestore'	
pod 'FirebaseAuth'	
pod 'FirebaseStorage'	
# pod 'FirebaseDatabase'
# pod 'Firebase'
# pod 'Firebase/Auth'

pod 'Firebase/Messaging'
#pod 'GoogleSignIn'
#pod 'GoogleSignInSwift'
# pod 'Firebase/Functions'

# pod 'BoringSSL-GRPC'

post_install do |installer|
      installer.pods_project.targets.each do |target|
        if target.name == 'BoringSSL-GRPC'
          target.source_build_phase.files.each do |file|
            if file.settings && file.settings['COMPILER_FLAGS']
              flags = file.settings['COMPILER_FLAGS'].split
              flags.reject! { |flag| flag == '-GCC_WARN_INHIBIT_ALL_WARNINGS' }
              file.settings['COMPILER_FLAGS'] = flags.join(' ')
            end
          end
        end
      #     target.build_configurations.each do |config|
      #     xcconfig_path = config.base_configuration_reference.real_path
      #     xcconfig = File.read(xcconfig_path)
      #     xcconfig_mod = xcconfig.gsub(/DT_TOOLCHAIN_DIR/, "TOOLCHAIN_DIR")
      #     File.open(xcconfig_path, "w") { |file| file << xcconfig_mod }
      #     end
      end
  end
end