task :default => :build

task :i => "lib/parser/edngrammar.rb" do
  sh "time gebuin edn-abnf.gemspec"
end

task :build => "lib/parser/edngrammar.rb" do
  sh "gem build edn-abnf.gemspec"
end

file "lib/parser/edngrammar.rb" => "lib/parser/edngrammar.treetop" do
  sh 'LANG="en_US.utf-8" tt lib/parser/edngrammar.treetop'
end

file "lib/parser/edngrammar.treetop" => "lib/parser/edngrammar.abnftt" do
  sh "abnftt lib/parser/edngrammar.abnftt"
  sh "diff lib/parser/edngrammar.abnf lib/parser/edn.abnf.orig"
end

