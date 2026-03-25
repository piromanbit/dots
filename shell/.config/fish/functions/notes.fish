function note
  set knowledge ~/doc/knowledge/
  set file ./00-inbox/brain-dump-$(date +%F).md

  cd $knowledge
  nvim $file
end
