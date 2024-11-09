
# Godot Dirt Cleaning Effect Shader

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/R6R115WI4Z)

Hey everyone.

This is updated for Godot 4.3

This shader simulates cleaning a surface of a plane for a "Dirt Cleaning" effect.

After searching online for a while I coudn't find any other tutorials that seemed to be straight forward for a simple plane so I made this.

It works by using a Collider for the plane, passing a raycast at the mouse coordinates, then translating those coordinates to local coordinates to the plane mesh. Then drawing on a mask and giving the new mask to the shader to remove the dirt.

You will have to modify how collision is handled most likely for your game. 

I also added a way to calculate how much of the dirt has been cleaned. 

![dirt_cleaning_shader](https://github.com/user-attachments/assets/b097788d-d80f-4e01-bdf2-09a1ea3df652)
