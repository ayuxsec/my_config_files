--[[
    run: conky -c "conky.conf"
    see more about conky: https://github.com/brndnmtthws/conky
]]

conky.config = {
    -- Window position and size
    alignment = 'top_right',
    gap_x = 24,
    gap_y = 24,
    minimum_width = 400,
    maximum_width = 400,
    background = false,
    border_width = 1,
    
    -- Window settings with semi-transparent background
    own_window = true,
    own_window_class = 'Conky',
    own_window_type = 'normal',
    own_window_transparent = false,
    own_window_argb_visual = true,
    own_window_argb_value = 195,  -- Semi-transparent
    own_window_colour = '#121214',  -- Dark background color
    own_window_hints = 'undecorated,below,sticky,skip_taskbar,skip_pager',
    
    -- Colors and fonts
    font = 'RobotoMono Nerd Font:size=10',
    font1 = 'RobotoMono Nerd Font:size=10:bold',  -- Bold for headings
    color0 = '#FFFFFF',  -- Bright white for important text
    color1 = '#f3f3f3',  -- Accent
    color2 = '#c8c8c8',  -- Accent dimmed
    color3 = '#808080',  -- Gray for less important info
    default_color = '#f3f3f3',  -- Default text color
    default_outline_color = 'white',
    default_shade_color = 'white',
    
    -- Appearance
    double_buffer = true,
    draw_borders = false,
    draw_graph_borders = true,
    draw_outline = false,
    draw_shades = false,
    extra_newline = false,
    use_xft = true,
    use_spacer = 'none',
    
    -- Other settings
    update_interval = 1.0,
    cpu_avg_samples = 4,
    net_avg_samples = 4,
    no_buffers = true,
    out_to_console = false,
    out_to_ncurses = false,
    out_to_stderr = false,
    out_to_x = true,
    show_graph_range = false,
    show_graph_scale = false,
    stippled_borders = 0,
    uppercase = false,
}

conky.text = [[
${voffset 8}
${goto 24}${font1}${color1} System Information ${font}${voffset 8}
${goto 24}${color1}OS:        ${color2}$sysname $nodename${alignr}${color1}
${goto 24}${color1}Kernel:    ${color2}$kernel${color1}
${goto 24}${color1}Machine:   ${color2}$machine${alignr}${color1}
${goto 24}${color1}Uptime:    ${color2}$uptime${color1}
${goto 24}${color1}CPU:       ${color2}${cpu}% ${cpubar 4,124}${alignr}${color1}Freq: ${color2}${freq_g} GHz

${goto 24}${font1}${color1} RAM & Swap ${font}${voffset 8}
${goto 24}${color1}RAM Used:  ${color2}$mem / $memmax ${alignr}${color1}${memperc}%
${goto 24}${color1}${membar 6,124}
${goto 24}${color1}RAM Free:  ${color2}$memfree${alignr}${color1}Available: ${color2}$memeasyfree
${voffset 4}
${goto 24}${color1}Swap Used: ${color2}$swap / $swapmax ${alignr}${color1}${swapperc}%
${goto 24}${color1}${swapbar 6,124}

${goto 24}${font1}${color1} Storage ${font}${voffset 8}
${goto 24}${color1}Root (/):  ${color2}${fs_used /} / ${fs_size /} ${alignr}${color1}${fs_used_perc /}%
${goto 24}${color1}${fs_bar 6,124 /}
${goto 24}${color1}I/O Read:  ${color2}${diskio_read}${alignr}${color1}Write: ${color2}${diskio_write}
${voffset 8}
${goto 24}${font1}${color1} Top Memory Processes ${font}${voffset 8}
${goto 24}${color0}Process             MEM%                  RAM${voffset 4}
${goto 24}${color2}${top_mem name 1} ${top_mem mem 1}% ${alignr}${top_mem mem_res 1}
${goto 24}${color2}${top_mem name 2} ${top_mem mem 2}% ${alignr}${top_mem mem_res 2}
${goto 24}${color2}${top_mem name 3} ${top_mem mem 3}% ${alignr}${top_mem mem_res 3}
${goto 24}${color2}${top_mem name 4} ${top_mem mem 4}% ${alignr}${top_mem mem_res 4}
${goto 24}${color2}${top_mem name 5} ${top_mem mem 5}% ${alignr}${top_mem mem_res 5}${voffset 8}

${goto 24}${font1}${color1} Top CPU Processes ${font}${voffset 8}
${goto 24}${color0}Process             CPU%                   PID${voffset 4}
${goto 24}${color2}${top name 1} ${top cpu 1}% ${alignr}${top pid 1}
${goto 24}${color2}${top name 2} ${top cpu 2}% ${alignr}${top pid 2}
${goto 24}${color2}${top name 3} ${top cpu 3}% ${alignr}${top pid 3}
${goto 24}${color2}${top name 4} ${top cpu 4}% ${alignr}${top pid 4}
${goto 24}${color2}${top name 5} ${top cpu 5}% ${alignr}${top pid 5}${voffset 8}
]]
