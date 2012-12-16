package {
  public class C {
    import flash.media.Sound;

    public static var size:int = 25;
    public static var dim:Vec = new Vec(25, 25);
    public static var DEBUG:Boolean = true;

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
      , "I come to. It's dark. I don't know where I am. It appears to be a sewer system."
      , "..."
      , "I don't know *who* I am."
      , "My only clue is a note I found in my pocket. It says the following:"
      , "'Infiltrate the Manor. Kill Daniel. Don't be seen.'"
      , "There is no signature."
      ]
    , [ "MEMORIES"
      , "A few memories come back to me, as if illuminated by a bright light."
      , "Laughter."
      , "Lyanne."
      , "They fade as I think about them."
      ]
    , [ "BLACK GUARDS"
      , "Unfortunately, the Manor where Daniel resides is guarded."
      , "Black guards are dumb. If I can stay out of the range of their flashlight,"
      , "I should be able to escape unseen."
      ]
    , [ "RED GUARDS"
      , "Red guards are pretty dumb too. They seem to just constantly spin in a circle."
      , "Don't they ever get dizzy?"
      ]
    , [ "BLUE GUARDS"
      , "Blue guards are smarter."
      , "They keep walking until they run into something."
      , "Then they turn around and do the same thing."
      , "But there is a silver lining."
      , "Blue guards seem to be totally unaware of their surroundings."
      , "If I were to move things around, I bet they wouldn't even notice."
      ]
    ];

    public static var toggledSwitch:Array = [
        "I hear the sound of energy draining and things turning off."
      ]

    public static var mapToJournal:Object = {
      ((new Vec(0, 0)).toString()) : 0
    }

    public static var warps:Object = {
      ((new Vec(3, 5)).toString()) : { "dest": new Vec(5, 5), "type": new Vec(0, 0) }
    };
  }
}

