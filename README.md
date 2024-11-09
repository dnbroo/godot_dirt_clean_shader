
# Godot Dirt Cleaning Effect Shader

Hey everyone.

This shader simulates cleaning a surface of a plane for a "Dirt Cleaning" effect. 

After searching online for a while I coudn't find any other tutorials that seemed to be straight forward for a simple plane so I made this. 

It works by using a Collider for the plane and then translating local coordinates to the plane mesh. Then drawing on a mask and using the shader to have the mask remove the parts of the dirty texture to show the clean texture underneath. 

![dirt_cleaning_shader](https://github.com/user-attachments/assets/b097788d-d80f-4e01-bdf2-09a1ea3df652)
