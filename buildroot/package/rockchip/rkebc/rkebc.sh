# rkebc properties

export rkebc_display_mode="norm_part"
export rkebc_keyframe_mode="norm_full"

# set log level, range [0, 2]
#   0  quite
#   1  info
#   2  debug
# export rkebc_log_level=2

# set color depth / contrast / saturation / luminance, range [0, 128]
# export rkebc_color_depth=64
# export rkebc_color_contrast=64
# export rkebc_color_saturation=64
# export rkebc_color_luminance=64

# how much image will dump to files
# export rkebc_dump_image=10

# When refresh count reaches this threshold, a full refresh is performed
# 0 means disabled
export rkebc_flush_threshold=0

# set rkcfa log level, range [0:4]
export rkcfa_loglevel=3

# set rkcfa watemark level, range [0:2]
export rkcfa_watermark=0

# alias define
alias setprop='rkebc_cmd setprop'
alias getprop='rkebc_cmd getprop'
