package {
  import flash.filters.*;

  public class Journal extends Entity {
  	private var JOURNAL_LIST:int = 0;
  	private var JOURNAL_SHOW:int = 1;

  	private var journalsSeen:Array = [];
  	private var journalMode:int = JOURNAL_LIST;
  	private var numJournals:int;
  	private var selectedJournal:int = 0;
  	private var currentlySelectedJournal:Boolean = false;

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

    public function show():void {
    	this.contents.visible = true;
    	Fathom.pushMode(C.MODE_JOURNAL);
    }

    private function renderText():void {
    	this.visible = true;

    	var overviewText:String;

    	if (!currentlySelectedJournal) {
	    	overviewText = "Arrow keys to navigate and space to select. J to exit.\n\n";

	    	for (var i:int = 0; i < journalsSeen.length; i++) {
				if (selectedJournal == i) overviewText += "*";
				overviewText += i + ": " + C.journalog[journalsSeen[i]][C.JOURNAL_TITLE];
				if (selectedJournal == i) overviewText += "*";

				overviewText += "\n";
	    	}
    	} else {
	    	overviewText = "Space to return to journal listing. J to leave.\n\n";

	    	overviewText += "*" + C.journalog[selectedJournal][0] + "* \n\n";
	    	overviewText += C.journalog[selectedJournal].concat().splice(1).join("\n");
    	}

    	contents.text = overviewText;
    }

    public function hide():void {
    	this.contents.visible = false;
    	Fathom.popMode();
    }

    override public function update(e:EntitySet):void {
    	if (Util.KeyJustDown.Down) {
    		selectedJournal = (selectedJournal + 1) % journalsSeen.length;
    	}

    	if (Util.KeyJustDown.Up) {
    		// Adding .length ensures we don't have to deal with modulo inconsistencies in negative numbers.
    		selectedJournal = (selectedJournal - 1 + journalsSeen.length) % journalsSeen.length;
    	}

    	if (Util.KeyJustDown.Space) {
    		currentlySelectedJournal = !currentlySelectedJournal;
    	}

    	if (Util.KeyJustDown.J) {
    		hide();
    	}

    	renderText();
    }

    override public function modes():Array {
    	return [C.MODE_JOURNAL];
    }

    override public function groups():Set {
      return super.groups().concat("non-blocking");
    }
  }
}
