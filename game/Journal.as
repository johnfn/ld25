package {
  import flash.filters.*;

  public class Journal extends Entity {
  	private var JOURNAL_LIST:int = 0;
  	private var JOURNAL_SHOW:int = 1;

  	private var journalsSeen:Array = [];
  	private var journalMode:int = JOURNAL_LIST;
  	private var numJournals:int;
  	private var selectedJournal:int = 0;

  	private var contents:Text;

    function Journal() {
    	super(0, 0);

    	addJournalEntry(0);
    	addJournalEntry(1);
    	addJournalEntry(2);
    	numJournals = C.journalog.length;

    	contents = new Text("", C.fontName);
    	contents.setPos(new Vec(0, 0));
    	contents.width = 300;
    	contents.height = 300;
    	//addChild(contents);
    }

    public function addJournalEntry(entry:int):void {
    	journalsSeen.push(entry);
    }

    public function display():void {
    	//Fathom.pushMode(C.MODE_JOURNAL);

    	var overviewText:String = "Arrow keys to navigate and enter to select.\n\n";

    	for (var i:int = 0; i < journalsSeen.length; i++) {
			if (selectedJournal == i) overviewText += "*";
			overviewText += i + ": " + C.journalog[journalsSeen[i]][C.JOURNAL_TITLE];
			if (selectedJournal == i) overviewText += "*";

			overviewText += "\n";
    	}

    	contents.text = overviewText;
    }

    public function hide():void {
    	Fathom.popMode();
    }

    override public function update(e:EntitySet):void {
    	if (Util.KeyJustDown.Down) {
    		selectedJournal = (selectedJournal + 1) % journalsSeen.length;
    	}

    	if (Util.KeyJustDown.Up) {
    		selectedJournal = (selectedJournal - 1 + journalsSeen.length) % journalsSeen.length;
    	}

    	display();
    }

    override public function groups():Set {
      return super.groups().concat("non-blocking");
    }
  }
}
