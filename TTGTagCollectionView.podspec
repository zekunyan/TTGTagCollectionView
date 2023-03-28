Pod::Spec.new do |s|
  s.name             = "TTGTagCollectionView"
  s.module_name      = "TTGTags"
  s.version          = "2.4.1"
  s.summary          = "Show rich style text tags or custom tag views in a vertical or horizontal scrollable view."
  
  s.description      = <<-DESC
                       TTGTagCollectionView is useful for showing different size tag views in a vertical or horizontal scrollable view and support Autolayout intrinsicContentSize at the same time. And if you only want to show text tags, you can use TTGTextTagCollectionView instead, which has more simple api. At the same time, It is highly customizable that many features of the text tag can be configured, like the tag font size and the background color.
                       DESC

  s.homepage         = "https://github.com/zekunyan/TTGTagCollectionView"
  s.license          = 'MIT'
  s.author           = { "zekunyan" => "zekunyan@163.com" }
  s.source           = { :git => "https://github.com/zekunyan/TTGTagCollectionView.git", :tag => s.version.to_s }
  s.social_media_url = 'http://tutuge.me'

  s.swift_version    = "5.0"
  s.platform         = :ios, '11.0'
  s.requires_arc     = true

  s.source_files = 'Sources/**/*.{h,m}'
  s.public_header_files = 'Sources/**/*.h'
end
