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
      [ "WHERE AM I?"
      , "I come to. It's dark. I don't know where I am. It appears to be a sewer system."
      , "..."
      , "I don't know *who* I am."
      , "My only clue is a note I found in my pocket. It says the following:"
      , "'Infiltrate the Manor. Kill Daniel. Don't be seen.'"
      , "There is no signature."
      ]
    , [ "SECURITY CAMERAS"
      , "I can't be seen by anyone or anything."
      , "That camera up ahead? Yeah. No good."
      , "It sees everything in the light in front of it."
      ]
    , [ "RUNNING"
      , "I feel energetic."
      , "I can throw caution to the wind and run with *X*."
      , "And by the way."
      , "I can look up these entries to my journal at any time by pressing *J*."
      ]
    , [ "PROBLEMS AHEAD"
      , "There's no way I can sneak past here."
      , "Maybe there's some way to turn the cameras off?"
      , "Assuming that I did in fact not turn them off yet."
      , "I should go look around."
      ]
    , [ "MEMORIES"
      , "A few memories come back to me, as if illuminated by a bright light."
      , "Laughter."
      , "Lyanne."
      , "They fade as I think about them."
      ]
    , [ "RED GUARDS"
      , "Unfortunately, the Manor where Daniel resides appears to be guarded."
      , "Red guards are dumb. If I can stay out of the range of their flashlight,"
      , "I should be able to escape unseen."
      ]
    , [ "GREEN GUARDS"
      , "Green guards are pretty dumb too. They seem to just constantly spin in a circle."
      , "Don't they ever get dizzy?"
      ]
    , [ "BLUE GUARDS"
      , "Blue guards are smarter."
      , "They keep walking until they run into something."
      , "Then they turn around and do the same thing."
      , "..."
      , "Now that I write it down, that's not really that smart."
      ]
    , [ "ONE GUARD, ONE HALL"
      , "Seems like Daniel has finally wisened up."
      , "There's no way I can get past here."
      , "Unless..."
      , "I should look around."
      ]
    ];

    public static var mapToJournal:Object = {
        ((new Vec(0, 0)).toString()) : 0
      , ((new Vec(2, 0)).toString()) : 1
      , ((new Vec(3, 3)).toString()) : 2
      , ((new Vec(3, 4)).toString()) : 3
      , ((new Vec(3, 5)).toString()) : 4
      , ((new Vec(5, 4)).toString()) : 5  // red guard.
      , ((new Vec(5, 3)).toString()) : 6
      , ((new Vec(6, 3)).toString()) : 7
      , ((new Vec(4, 3)).toString()) : 8
    };

    public static var toggledSwitch:Array = [
        "I hear the sound of energy draining and things turning off."
      ];

    public static var gotPoisonDarts:Array = [
        "I open the chest."
      , "Inside, I find *poison darts*."
      , "I can fire them with *Z*."
      , "Interesting..."
      ];

    public static var gotTranqDarts:Array = [
        "I open the chest."
      , "Inside, I find *tranquilizer darts*."
      , "They'll make the target fall asleep for a brief period."
      , "I can fire them with *Z*."
      , "Interesting..."
      ];

    public static var alreadyHasPoison:Array = [
        "I open the chest."
      , "Inside, I find *tranquilizer darts*."
      , "They'll make the target fall asleep for a brief period."
      , "I'll swap my poison darts for these."
      ];

    public static var alreadyHasTranq:Array = [
        "I open the chest."
      , "Inside, I find *poison darts*."
      , "But since I already have tranquilizers, I think I'll stick with them for now."
      ];

    public static var warps:Object = {
        ((new Vec(3, 5)).toString()) : { "dest": new Vec(5, 5), "type": new Vec(0, 0) }
      , ((new Vec(6, 4)).toString()) : { "dest": new Vec(5, 1), "type": new Vec(1, 0) }
      , ((new Vec(3, 0)).toString()) : { "dest": new Vec(5, 5), "type": new Vec(1, 0) }
    };
  }
}

