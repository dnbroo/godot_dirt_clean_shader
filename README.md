
# Godot Dirt Cleaning Effect Shader

Hey everyone.

This shader simulates cleaning a surface of a plane for a "Dirt Cleaning" effect. 

After searching online for a while I coudn't find any other tutorials that seemed to be straight forward for a simple plane so I made this. 

It works by using a Collider for the plane and then translating local coordinates to the plane mesh. Then drawing on a mask and using the shader to have the mask remove the parts of the dirty texture to show the clean texture underneath. 

![App Screenshot]([https://via.placeholder.com/468x300?text=App+Screenshot+Here](https://github.com/dnbroo/godot_dirt_clean_shader/blob/main/images/dirt_cleaning_shader.gif))
