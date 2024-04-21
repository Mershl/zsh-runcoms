#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...
alias mpv='flatpak run io.mpv.Mpv'
alias meld='flatpak run org.gnome.meld'
alias lutris='flatpak run net.lutris.Lutris'

ffmpeg_resize () {
    file=$1
    target_size_mb=$2  # target size in MB
    target_size=$(( $target_size_mb * 1000 * 1000 * 8 )) # target size in bits
    length=`ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$file"`
    length_round_up=$(( ${length%.*} + 1 ))
    total_bitrate=$(( $target_size / $length_round_up ))
    audio_bitrate=$(( 128 * 1000 )) # 128k bit rate
    video_bitrate=$(( $total_bitrate - $audio_bitrate ))
    ffmpeg -i "$file" -b:v $video_bitrate -maxrate:v $video_bitrate -bufsize:v $(( $target_size / 20 )) -b:a $audio_bitrate "${file}-${target_size_mb}mb.mp4"
}
