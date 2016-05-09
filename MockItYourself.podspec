Pod::Spec.new do |s|
  s.name             = "MockItYourself"
  s.version          = "1.0.0"
  s.summary          = "MockItYourself is a simple mocking framework for Swift"
  s.description      = <<-DESC
MockItYourself is a mocking framework for Swift. 
Currently, Swift has read-only reflection and it is therefore impossible to create a dynamic mocking framework like OCMock. 
MockItYourself reduces the boilerplate needed to manually create mocks and is heavily inspired by SwiftMock.
                       DESC

  s.homepage         = "https://github.com/plain-vanilla-games/MockItYourself"
  s.license          = 'MIT'
  s.author           = { "Alexey Verein" => "alexey@plainvanillagames.com", 
                          "Jóhann Þ. Bergþórsson" => "johann@plainvanillagames.com",
                          "Magnus Ó. Magnússon" => "magnus@plainvanillagames.com"}
  
  s.source           = { :git => "https://github.com/plain-vanilla-games/MockItYourself.git", :tag => s.version.to_s }
  s.source_files = 'MockItYourself/**/*.swift'

  s.ios.deployment_target = '8.0'

  s.frameworks = 'XCTest'
end
