Project BlackBook
===================


About the project
----------
BlackBook is a pure Ruby 3D Library that aims developers to write their 3D applications with ease of Ruby. Please keep in mind that, this project is still a **work in progress** and is **not suitable to use** I suppose. But try it for yourself. Feel free to fix it, improve it and be a contributor for the project.


Documents
-------------

For documentation, I am trying to write as many comments as possible and keep the code clean and meaningful with giving proper variable names and keeping a standard. 
Some parts of the code is messy, as I mentioned, I did not refactor it yet.
Documentations are generated with **yardoc** and code standards can be checked with **rubocop**. I needed to flex the standards a bit. ;)

I hope you enjoy it. You can find the requirements inside Gemfile.
After all, just give it a shot!

    ruby main.rb


Registry
--------------
There are some global variables that you might need to define in your application setup;

    BlackBook::Registry.instance.write('grid', true)            # Draw grid
    BlackBook::Registry.instance.write('grid_count', 100)      # Grid line count
    BlackBook::Registry.instance.write('grid_size', 2)      # Grid line count
    BlackBook::Registry.instance.write('data_path', '../data') # Data path, especially needed for fonts.
    BlackBook::Registry.instance.write('shader', 'vbo')         # Set object shading to Virtual Buffer Objects
    BlackBook::Registry.instance.write('shader', 'displaylist') # Set object shading to display lists



RAW Object Files
----------------
3D Raw Object files are simply exports from Blender3D as raw text format.


Syntax Control
--------------
Please use **check\_syntax.sh** for syntax control and do not change .rubocop_todo.yml


Notes about known bugs
-----------------------

If you come accross a situation where things seem not to fit the screen, you may need to change

    w = BlackBook::Main.new(800, 600, 'BlackBook Project', 2, 2)

to

    w = BlackBook::Main.new(800, 600, 'BlackBook Project', 1, 1)

There is something weird about screen occupation and I still don't know why :)


Seems like, I broke the Physics Engine during my structure renewal. Sorry :) I will fix it ASAP and also fix the 8_physics.rb sample.
