package {
  public class C {
    import flash.media.Sound;

    public static var size:int = 25;
    public static var dim:Vec = new Vec(25, 25);

    public static var DEBUG:Boolean = false;

    // Fonts.

    // embedAsCCF MUST be set to false if you want anything to show up at all.
    [Embed(source="../data/04b03.ttf", embedAsCFF="false", fontFamily="BittyFont", mimeType="application/x-font")]
    public static var fontClass:String;
    public static var fontName:String = "BittyFont";

    // Graphics.
    [Embed(source = "../data/map.png")] static public var MapClass:Class;
    [Embed(source = "../data/sprites.png")] static public var SpritesClass:Class;
    [Embed(source = "../data/blacksquare.png")] static public var BlackSquareClass:Class;

    // Physics.

    public static var GRAVITY:Number = 0.4;

    // Game modes.
    public static var MODE_NORMAL:int    = 0; // Should be the only unpaused mode.
    public static var MODE_JOURNAL:int   = 1;
    public static var MODE_TEXT:int      = 2;

    public static var JOURNAL_TITLE:int = 0;

    public static var journalog:Array = [
      [ "JOURNAL ENTRY #1"
      , "I've come to. It's dark. Wind rustles through the trees. I don't know where I am."
      , "..."
      , "I don't know *who* I am."
      , "My only clue is a note I found in my pocket. It says the following:"
      , "'Infiltrate the Manor. Kill Daniel. Don't be seen.'"
      , "There is no signature."
      ]
    , [ "A few memories come back to me, as if illuminated by a bright light."
      , "Laughter."
      , "Lyanne."
      , "They fade as soon as I think about them."
      ]
    , [ "Black Guards"
      , "Unfortunately, the Manor where Daniel resides is guarded."
      , "Black guards are dumb. If I can stay out of the range of their flashlight,"
      , "I should be able to escape unseen."
      ]
    , [ "Red Guards"
      , "Red guards are pretty dumb too. They seem to just constantly spin in a circle."
      , "Don't they ever get dizzy?"
      ]
    , [ "Blue Guards"
      , "Blue guards are smarter."
      , "They keep walking until they run into something."
      , "Then they turn around and do the same thing."
      , "But there is a silver lining."
      , "Blue guards seem to be totally unaware of their surroundings."
      , "If I were to move things around, I bet they wouldn't even notice."
      ]
    ];

    public static var mapToJournal:Object = {
      ((new Vec(0, 0)).toString()) : 0
    }

    public static var warps:Object = {
      //((new Vec(0, 0)).toString()) : { "dest": new Vec(0, 1), "type": new Vec(2, 0) }
    };
  }
}

