package {

	import flash.display.MovieClip;
	import flash.events.Event;

	public class Screens extends MovieClip {


		public function Screens() {

			gotoMainMenu();

			stop();

		}
		private function gotoNewGame(e:Event=null) {
			dispatchEvent(new Event("newGame"));
			clearMenu()
		}
		private function gotoContinue(e:Event=null) {
			dispatchEvent(new Event("newGame"));
			clearMenu()
		}
		public function gotoInstructions(e:Event=null) {
			gotoAndStop(3);
			getChildByName("mainMenu_btn").addEventListener("click", gotoMainMenu);
		}
		public function gotoAchievments(e:Event=null) {
			dispatchEvent(new Event("newGame"));
		}
		public function gotoMainMenu(e:Event=null) {
			gotoAndStop(1);
			getChildByName("newGame_btn").addEventListener("click", gotoNewGame);
			getChildByName("continue_btn").addEventListener("click", gotoContinue);
			getChildByName("instructions_btn").addEventListener("click", gotoInstructions);
			getChildByName("achievments_btn").addEventListener("click", gotoAchievments);
		}
		public function clearMenu() {
			gotoAndStop(5);
		}
	}

}