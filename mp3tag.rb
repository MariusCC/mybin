=begin
= Synopsis

Read the tag from a file or create and Mp3Tag instance for saving tag to
mp3 file later:

   tag = Mp3Tag.new(filename)

Examining tags:

   tag.songname
   tag.artist
   tag.album
   tag.year
   tag.comment
   tag.tracknum
   tag.genre_id
   tag.genre

Setting tags:

   tag.songname = "My Song"
   tag.artist = "Me"
   tag.album = "My Album"
   tag.year = "2001"
   tag.comment = "No Comment"
   tag.tracknum = 3

   tag.genre_id = 23
   tag.genre = "Drum Solo"

genre_id's should exist in Mp3Tag::Genres. Elements in Mp3Tag::Genres
can be assigned using tag.genre= and the id will be looked up
automatically.

Saving tag to mp3:

   tag.commit

Checking if a file has a tag:

   Mp3Tag.hastag?(filename)

=end

# '

class Mp3Tag

  VERSION = '1.0'

  Genres = [ 'Blues', 'Classic Rock', 'Country', 'Dance',
    'Disco', 'Funk', 'Grunge', 'Hip-Hop', 'Jazz', 'Metal', 'New Age',
    'Oldies', 'Other', 'Pop', 'R&B', 'Rap', 'Reggae', 'Rock', 'Techno',
    'Industrial', 'Alternative', 'Ska', 'Death Metal', 'Pranks',
    'Soundtrack', 'Euro-Techno', 'Ambient', 'Trip-Hop', 'Vocal',
    'Jazz+Funk', 'Fusion', 'Trance', 'Classical', 'Instrumental',
    'Acid', 'House', 'Game', 'Sound Clip', 'Gospel', 'Noise',
    'Alternative Rock', 'Bass', 'Soul', 'Punk', 'Space', 'Meditative',
    'Instrumental Pop', 'Instrumental Rock', 'Ethnic', 'Gothic',
    'Darkwave', 'Techno-Industrial', 'Electronic', 'Pop-Folk',
    'Eurodance', 'Dream', 'Southern Rock', 'Comedy', 'Cult', 'Gangsta',
    'Top 40', 'Christian Rap', 'Pop/Funk', 'Jungle', 'Native US',
    'Cabaret', 'New Wave', 'Psychadelic', 'Rave', 'Showtunes',
    'Trailer', 'Lo-Fi', 'Tribal', 'Acid Punk', 'Acid Jazz', 'Polka',
    'Retro', 'Musical', 'Rock & Roll', 'Hard Rock', 'Folk', 'Folk-Rock',
    'National Folk', 'Swing', 'Fast Fusion', 'Bebob', 'Latin',
    'Revival', 'Celtic', 'Bluegrass', 'Avantgarde', 'Gothic Rock',
    'Progressive Rock', 'Psychedelic Rock', 'Symphonic Rock',
    'Slow Rock', 'Big Band', 'Chorus', 'Easy Listening', 'Acoustic', 'Humour',
    'Speech', 'Chanson', 'Opera', 'Chamber Music', 'Sonata', 'Symphony',
    'Booty Bass', 'Primus', 'Porn Groove', 'Satire', 'Slow Jam', 'Club',
    'Tango', 'Samba', 'Folklore', 'Ballad', 'Power Ballad', 'Rhytmic Soul',
    'Freestyle', 'Duet', 'Punk Rock', 'Drum Solo', 'Acapella',
    'Euro-House', 'Dance Hall', 'Goa', 'Drum & Bass', 'Club-House',
    'Hardcore', 'Terror', 'Indie', 'BritPop', 'Negerpunk', 'Polsk Punk',
    'Beat', 'Christian Gangsta Rap', 'Heavy Metal', 'Black Metal',
    'Crossover', 'Contemporary Christian', 'Christian Rock', 'Merengue',
    'Salsa', 'Trash Metal', 'Anime', 'Jpop', 'Synthpop' ]

  attr_accessor :songname, :artist, :album, :comment
  attr_reader :path, :year, :tracknum, :genre_id

  TagSize = 128
  TAGFORMAT_WRITE = 'Z30Z30Z30Z4Z28CCC'# write zero padded
  TAGFORMAT_READ = 'A30A30A30A4A30C'# accept zero/space padded input

=begin
= Class Methods
--- Mp3Tag.new(path)
      Creates a new Mp3Tag object for the file give by ((|path|)).
=end

  def initialize(path)
    @path = path

    @genre_id = 255
    @songname = ''
    @artist = ''
    @album = ''
    @comment = ''
    @tracknum = 0
    @year = 0

    readtag
  end

=begin
--- Mp3Tag.hastag?(filename)
      Tests if ((|filename|)) has a ID3V1.0 or ID3V1.1 tag. Returns a boolean values giving the result of the test.
=end

  def Mp3Tag.hastag?(file)
    hastag = nil
    File.open(file, 'r') { |f|
      f.seek(-TagSize, IO::SEEK_END)
      tag = f.read(3)
      hastag = (tag == 'TAG')
    }
    return hastag
  end

=begin
--- Mp3Tag.removetag(filename)
      Removes an ID3v1 tag from the MP3 file ((|filename|))
=end

  def Mp3Tag.removetag(filename)
    if Mp3Tag.hastag?(filename)
      newsize = File.size(filename) - TagSize
      File.open(filename, 'r+') {
	|f|
	f.truncate(newsize)
      }
    end
  end

=begin
= Instance Methods
--- songname
--- artist
--- album
--- comment
      Return the song name, artist, album, or comment from the tag as a String object. Will return empty strings if file did not have a tag.
--- tracknum
      Returns the track number from the tag. Will return 0 if the track number was not set in the tag when loaded, or if the file had no tag.
--- year
      Returns the year from the tag. Will return 0 if the file had no tag.
--- genre_id
      Return the id number of the genre from the tag. Will return 255 if the file had no tag.
--- genre
      Returns the genre name. Will return "Unknown" if the file had no tag or the genre id was not in Mp3Tag::Genres
--- path
      Returns the full path name of the MP3 file.
--- filename
      Returns the filename without the directory part of the MP3 File.
--- songname=(txt)
--- artist=(txt)
--- album=(txt)
--- comment=(txt)
      Sets the song name, atist, album, or comment for the tag to ((|txt|)). ((|txt|)) should be a String object.
--- tracknum=(num)
      Sets the track number for the tag. Only values in the range (0..255) are allowed.
--- year=(num)
      Sets the year for the tag. Should be a four digit number.
--- genre_id=(num)
      Sets the the genre id for the tag. Only values in the range (0..255) are allowed.
--- genre=(txt)
      Sets the genre id for the tag to the index of ((|txt|)) in Mp3Tag::Genres. The genre id will be set to 255 if ((|txt|)) is not found in the list.

=end

  def tracknum=(num)
    @tracknum = num.to_i
  end

  def year=(year)
    @year = year.to_i
  end

  def genre=(genre)
    @genre_id = Genres.index(genre) || 255
  end

  def genre_id=(id)
    @genre_id = id.to_i
  end
 
  def genre
    Genres[@genre_id] || 'Unknown'
  end

  def filename
    File.basename(@path)
  end

  def readtag
    return if File.size(@path) < TagSize
    File.open(@path, 'r') {
      |f|
      f.seek(-TagSize, IO::SEEK_END)
      tag = f.read(3)
      if (tag == 'TAG')
	rest = f.read(TagSize-3)
	# Read id3v1.0 tag
	@songname, @artist, @album, @year_s, @comment, @genre_id = rest.unpack TAGFORMAT_READ
	@year = @year_s.to_i
	# Handle id3v1.1 tracknums
	if @comment[28] == 0
	  @tracknum = @comment[29]
	  @comment.sub!(/\000+.$/, '')# remove nulls and tracknum from comment
	end
      end
    }
  end
  private :readtag

=begin
--- commit
      Saves the tag to the MP3 file. Will overwrite any existing tag.
=end

  def commit
    File.open(@path, 'r+') {
      |f|
      f.seek(-TagSize, IO::SEEK_END)
      tag = f.read(3)
      if tag != 'TAG'
	# Append new tag
	f.seek(0, IO::SEEK_END)
	f.write('TAG')
      end
      f.write([@songname,@artist,@album, ("%04d" % @year), @comment, 0, @tracknum, @genre_id].pack(TAGFORMAT_WRITE))
    }
  end

end

