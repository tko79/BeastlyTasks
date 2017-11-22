# NOTES

Here are some notes and ideas:

example tasks
- gertrud - daily - tickling the turtle, getrud is her name
- chili - weekly - water the chili
- parents - weekly - phone parents
- tax - yearly - tax declaration - end of May

user interfaces / modes
- cli: interactive mode
- cli: non-interactive mode (via parameters)
- web-ui: daemon mode
- conky: system monitor

misc
- configurable dashboard
- calculate some statistics
- config format: yaml/xml

task visualization
- example image docs/images/task_example.jpg can be created with an empty template and `convert` command
- using convert to add the text: `convert task_template_red.png -gravity Center -pointsize 20 -fill white -draw "text 0,-13 'task#01'" -draw "text -60,20 'cw47/17'" -draw "text 60,20 'tbd'" /tmp/test.jpg`
- tasks could be marked as done using another template and composite command: `composite -gravity center task_example.png task_template_done.png task_example_done.png`
