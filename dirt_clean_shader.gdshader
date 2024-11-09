shader_type spatial;

uniform sampler2D clean_texture;
uniform sampler2D dirty_texture;
uniform sampler2D dirt_mask;

// Control for the amount of dirtiness applied
uniform float dirt_strength : hint_range(0.0, 1.0) = 1.0;

void fragment() {
    // Sample colors from the clean and dirty textures
    vec4 clean_color = texture(clean_texture, UV);
    vec4 dirty_color = texture(dirty_texture, UV);

    // Sample the dirt mask (typically a grayscale texture)
    float mask_value = texture(dirt_mask, UV).r;

    // Adjust the mask by dirt_strength to control the blending
    float adjusted_mask = mask_value * dirt_strength;

    // Final blend factor considering both the mask and the dirty texture's alpha
    float blend_factor = adjusted_mask * dirty_color.a;

    // Blend the clean and dirty colors, preserving some of the clean texture's influence
    vec4 final_color = mix(clean_color, dirty_color, blend_factor);

    // For ALPHA, use the higher of clean or dirty alpha to ensure visibility
    ALBEDO = final_color.rgb;
    ALPHA = max(clean_color.a, blend_factor);
}
