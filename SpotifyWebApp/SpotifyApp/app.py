import warnings
warnings.filterwarnings("ignore", category=FutureWarning)
from flask import abort, render_template, Flask
import logging
import db

APP = Flask(__name__)

# Start page
@APP.route('/')
def index():
    stats = {}
    x = db.execute('SELECT COUNT(*) AS users FROM USER').fetchone()
    stats.update(x)
    x = db.execute('SELECT COUNT(*) AS songs FROM SONG').fetchone()
    stats.update(x)
    x = db.execute('SELECT COUNT(*) AS artists FROM ARTIST').fetchone()
    stats.update(x)
    x = db.execute('SELECT COUNT(*) AS genres FROM GENRE').fetchone()
    stats.update(x)
    logging.info(stats)
    return render_template('index.html',stats=stats)

# Iniciar bd 
# Buscar db.sql na pasta sql
@APP.route('/init/')
def init():
    return render_template('init.html', init=db.init())

@APP.route('/users/')
def list_users():
    users = db.execute(
        '''
        SELECT U.ULogin, U.Name, U.Joined, U.BirthDate, U.Sex, U.Email, U.Phone
        FROM USER U
        ORDER BY U.Name
        '''
    ).fetchall()

    return render_template('users-list.html', users=users)


@APP.route('/artists/')
def list_artists():
    artists = db.execute(
        '''
        SELECT A.ALogin, A.Name, A.Verified
        FROM ARTIST A 
        ORDER BY A.Name
        '''
    ).fetchall()

    return render_template('artists-list.html', artists=artists)


@APP.route('/songs/')
def list_songs():
    songs = db.execute(
      '''
      SELECT S.SId, S.Name, S.PostDate, A.Name AS CreatorName
      FROM SONG S JOIN ARTIST A ON(Creator = ALogin)
      ORDER BY S.Name
      '''
    ).fetchall()
    return render_template('song-list.html', songs=songs)


@APP.route('/genres/')
def list_genres():
    genres = db.execute('''
      SELECT G.GId, G.Label 
      FROM GENRE G
      ORDER BY Label
    ''').fetchall()
    return render_template('genre-list.html', genres=genres)


@APP.route('/users/<int:id>/')
def get_user(id):
    user = db.execute(
        '''
        SELECT U.ULogin, U.Name, U.Joined, U.BirthDate, U.Sex, U.Email, U.Phone
        FROM USER U
        WHERE U.ULogin = %s
        ORDER BY U.Name
        ''', id).fetchone()
    
    if user is None:
        abort(404, 'User Login {} not found.'.format(id));

    playlists = db.execute(
        '''
        SELECT PId, P.Name
        FROM PLAYLIST P JOIN USER ON(Creator = ULogin)
        WHERE ULogin = %s
        ORDER BY P.Name
        ''', id).fetchall()

    followers = db.execute(
        '''
        SELECT F.ULogin, F.Name FROM USER F
        JOIN USER_FOLLOWER ON(Follower = F.ULogin)
        JOIN USER U ON(User = U.ULogin)
        WHERE U.ULogin = %s
        ORDER BY F.Name
        ''', id).fetchall()

    song_likes = db.execute(
        '''
        SELECT S.SId, S.Name
        FROM SONG S NATURAL JOIN SONG_LIKED
        WHERE ULogin = %s
        ORDER BY S.Name
        ''', id).fetchall()
    
    album_likes = db.execute(
        '''
        SELECT A.AId, A.Name
        FROM ALBUM A NATURAL JOIN ALBUM_LIKED
        WHERE ULogin = %s
        ORDER BY A.Name
        ''', id).fetchall()

    playlist_likes = db.execute(
        '''
        SELECT P.PId, P.Name
        FROM PLAYLIST P NATURAL JOIN PLAYLIST_LIKED
        WHERE ULogin = %s
        ORDER BY P.Name
        ''', id).fetchall()

    return render_template('user.html', 
    user=user, playlists = playlists, followers=followers, 
    song_likes=song_likes, album_likes=album_likes, playlist_likes=playlist_likes)


@APP.route('/artists/<int:id>/')
def get_artist(id):
    artist = db.execute(
        '''
        SELECT A.ALogin, A.Name, A.Verified 
        FROM ARTIST A
        WHERE A.ALogin = %s 
        ''', id).fetchone()
    
    if artist is None:
        abort(404, 'Artist Id {} not found.'.format(id));

    songs = db.execute(
        '''
        SELECT S.SId, S.Name
        FROM SONG S JOIN ARTIST A ON(S.Creator = A.ALogin)
        WHERE A.ALogin = %s
        ORDER BY S.Name
        ''', id).fetchall()

    albums = db.execute(
        '''
        SELECT A.AId, A.Name
        FROM ALBUM A JOIN ARTIST ON(A.Creator = ALogin)
        WHERE ALogin = %s
        ORDER BY A.Name
        ''', id).fetchall()

    followers = db.execute(
        '''
        SELECT F.ULogin, F.Name
        FROM USER F
        JOIN ARTIST_FOLLOWER ON(Follower = F.ULogin)
        JOIN ARTIST A ON(Artist = A.ALogin)
        WHERE A.ALogin = %s
        ORDER BY F.Name
        ''', id).fetchall()
    
    return render_template('artist.html', 
    artist=artist, songs=songs, albums=albums, followers=followers)


@APP.route('/songs/<int:id>/')
def get_song(id):
  song = db.execute(
      '''
      SELECT SId, Name, Creator, PostDate 
      FROM SONG 
      WHERE SId = %s
      ''', id).fetchone()

  if song is None:
     abort(404, 'Song id {} does not exist.'.format(id))

  artist = db.execute(
      '''
      SELECT A.ALogin, A.Name AS Name
      FROM ARTIST A
      JOIN SONG S ON(Creator=ALogin)
      WHERE S.SId = %s
      Order by A.Name
      ''', id).fetchone()
  
  album = db.execute(
      '''
      SELECT AId, A.Name AS Name
      FROM ALBUM A
      JOIN ARTIST ON(A.Creator = ALogin)
      JOIN SONG S ON(S.Creator = ALogin)
      WHERE SId = %s
      ORDER BY A.Name
      ''', id).fetchone()

  playlists = db.execute(
      '''
      SELECT P.PId, P.Name 
      FROM PLAYLIST P NATURAL JOIN PLAYLIST_SONG 
      JOIN SONG S USING(SId)
      WHERE S.SId = %s
      ORDER BY P.Name
      ''', id).fetchall()

  genres = db.execute(
      '''
      SELECT G.GId, G.Label
      FROM GENRE G NATURAL JOIN SONG_GENRE
      NATURAL JOIN SONG S
      WHERE S.SId = %s
      ORDER BY G.Label
      ''', id).fetchall()

  users = db.execute(
      '''
      SELECT U.ULogin, U.Name
      FROM USER U NATURAL JOIN SONG_LIKED
      WHERE SId = %s
      ORDER BY U.Name
      ''', id).fetchall()

  return render_template('song.html', 
           artist=artist, album=album, song=song, playlists=playlists, 
           genres=genres, users=users)


@APP.route('/playlists/<int:id>')
def get_playlist(id):
    playlist = db.execute(
        '''
        SELECT P.PId, P.Name, P.Creator, P.CreationDate
        FROM PLAYLIST P
        WHERE P.PId = %s
        ''', id).fetchone()

    if playlist is None:
        abort(404, 'Playlist Id {} not found.'.format(id))

    user = db.execute(
        '''
        SELECT U.ULogin, U.Name
        FROM USER U 
        JOIN PLAYLIST P ON(P.Creator = U.ULogin)
        WHERE P.PId = %s
        ''', id).fetchone()

    songs = db.execute(
        '''
        SELECT S.SId, S.Name
        FROM SONG S JOIN PLAYLIST_SONG USING(SId)
        JOIN PLAYLIST P USING(PId)
        WHERE P.PId = %s
        ''', id).fetchall()

    users = db.execute(
      '''
      SELECT U.ULogin, U.Name
      FROM USER U NATURAL JOIN PLAYLIST_LIKED
      WHERE PId = %s
      ORDER BY U.Name
      ''', id).fetchall()
    
    return render_template('playlist.html', playlist=playlist, user=user, 
    songs=songs, users=users)


@APP.route('/albums/<int:id>')
def get_album(id):
    album = db.execute(
        '''
        SELECT A.AId, A.Name, A.Creator, A.CreationDate
        FROM ALBUM A
        WHERE A.AId = %s
        ''', id).fetchone()

    if album is None:
        abort(404, 'Album Id {} not found.'.format(id))

    artist = db.execute(
        '''
        SELECT A.ALogin, A.Name
        FROM ARTIST A JOIN ALBUM ON(Creator = A.ALogin)
        WHERE AId = %s
        ''', id).fetchone()

    songs = db.execute(
        '''
        SELECT S.SId, S.Name
        FROM SONG S NATURAL JOIN ALBUM_SONG
        JOIN ALBUM A USING(AId)
        WHERE A.AId = %s
        ORDER BY S.Name
        ''', id).fetchall()

    users = db.execute(
      '''
      SELECT U.ULogin, U.Name
      FROM USER U NATURAL JOIN ALBUM_LIKED
      WHERE AId = %s
      ORDER BY U.Name
      ''', id).fetchall()
    
    return render_template('album.html', album=album, artist=artist, 
    songs=songs, users=users)


@APP.route('/genres/<int:id>/')
def view_songs_by_genre(id):
  genre = db.execute(
    '''
    SELECT G.GId, G.Label
    FROM GENRE G
    WHERE GId = %s
    ''', id).fetchone()

  if genre is None:
     abort(404, 'Genre id {} does not exist.'.format(id))

  songs = db.execute(
    '''
    SELECT S.SId, S.Name
    FROM SONG S NATURAL JOIN SONG_GENRE G
    WHERE G.GId = %s
    ORDER BY S.Name
    ''', id).fetchall()

  return render_template('genre.html', 
           genre=genre, songs=songs)


@APP.route('/users/search/<expr>/')
def search_user(expr):
    search = { 'expr': expr}
    expr = '%' + expr + '%'
    users = db.execute(
        '''
        SELECT U.ULogin, U.Name 
        FROM USER U
        WHERE Name LIKE %s
        ORDER BY U.Name
        ''', expr).fetchall()

    return render_template('user-search.html', search=search, users=users)


@APP.route('/artists/search/<expr>/')
def search_artist(expr):
    search = { 'expr': expr}
    expr = '%' + expr + '%'
    artists = db.execute(
        '''
        SELECT A.ALogin, A.Name 
        FROM ARTIST A
        WHERE A.Name LIKE %s
        ORDER BY A.Name
        ''', expr).fetchall()

    return render_template('artist-search.html', search=search, artists=artists)


@APP.route('/songs/search/<expr>/')
def search_song(expr):
  search = { 'expr': expr }
  expr = '%' + expr + '%'
  songs = db.execute(
      ''' 
      SELECT S.SId, S.Name
      FROM SONG S
      WHERE Name LIKE %s
      ORDER BY S.Name
      ''', expr).fetchall()
  return render_template('song-search.html',
           search=search,songs=songs)


@APP.route('/genres/search/<expr>/')
def search_genre(expr):
  search = { 'expr': expr }
  expr = '%' + expr + '%'
  genres = db.execute(
      ''' 
      SELECT GId, Label
      FROM GENRE
      WHERE Label LIKE %s
      ORDER BY Label
      ''', expr).fetchall()

  return render_template('genre-search.html',
           search=search, genres=genres)