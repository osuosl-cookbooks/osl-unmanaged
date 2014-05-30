#!/usr/bin/env ruby

def keep_cookbookp(cb)
  return `knife search node 'recipes:#{cb}*' -i | head -n 1 | cut -d' ' -f1 | tr -d ' '`.to_i != 0
end


cookbooks = `knife cookbook list | cut -d' ' -f1`.split
cookbooks_to_keep = []
cookbooks.each do |cb|
  unless keep_cookbookp(cb)
    next
  else
    unless cookbooks_to_keep.include?(cb)
      deps = `knife solve #{cb} | tail -n +2 | cut -d' ' -f1`.split
      cookbooks_to_keep << cb
      deps.each do |dep|
        cookbooks_to_keep << dep
      end
    end
  end
end

cookbooks_to_keep.uniq!
puts "The following cookbooks may be deleted: #{(cookbooks - cookbooks_to_keep).join(", ")}"
