task :default => :build

targets = ["lib/parser/edngrammar.rb", "lib/cbor-diagnostic-app/hgrammar.rb"]

task :i => targets  do
  sh "time gebuin edn-abnf.gemspec"
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
