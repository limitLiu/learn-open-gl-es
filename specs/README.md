# OpenCV-pod

## Usage

U can clone it into your project.

```bash
$ cd <Your Project Name>
$ git clone https://github.com/limitLiu/OpenCV-pod.git specs
```

```ruby
platform :ios, '9.0'

project '<Your Project Name>'

target '<Your Target Name>' do
  
  use_frameworks!
  
  # use local file
  pod 'OpenCV', :podspec => './specs/OpenCV.podspec.json'

end
```

