desc "rebuild the backbone_serialize_model-min.js files for distribution"
task :build do
  system 'coffee -m -c serialize_backbone_model.coffee'
  system 'uglifyjs serialize_backbone_model.js --mangle --source-map serialize_backbone_model-min.map -o serialize_backbone_model-min.js'
end

task :clean do
  system 'rm -f *.map serialize_backbone_model.js serialize_backbone_model-min.js'
end

task :test do
  system 'coffee -m -c test/save.coffee'
#  system 'open test/index.html'
end