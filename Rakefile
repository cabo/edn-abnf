task :default => :build

subgrammars = Dir["lib/cbor-diagnostic-app/*.abnftt"].map {|x| x.sub(/[.]abnftt$/, '.rb')}
p subgrammars.map {|x| File.basename(x, ".rb")}
targets = ["lib/parser/edngrammar.rb", *subgrammars]

task :t do
  Dir.glob("tests/*.csv") do |test|
    puts "______________ testing #{test}"
    sh "edn-abnf -l #{test}"
  end
end
task :v do
  Dir.glob("tests/*.csv") do |test|
    puts "______________ testing #{test}"
    sh "edn-abnf -vl #{test}"
  end
end
task :w do
  Dir.glob("tests/*.csv") do |test|
    puts "______________ testing #{test}"
    sh "edn-abnf -vli #{test}"
  end
end

task :i => targets  do
  sh "time ./gebuin edn-abnf.gemspec"
end

task :build => targets do
  sh "gem build edn-abnf.gemspec"
end

rule ".rb" => ".treetop" do |t|
  sh %{LANG="en_US.utf-8" tt #{t.source}}
end

rule '.treetop' => ['.abnftt'] do |t|
  sh "abnftt #{t.source}"
  bn = t.source.sub(/[.]abnftt$/, '')
  sh "diff #{bn}.abnf #{bn}.abnf.orig"
end
