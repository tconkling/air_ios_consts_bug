package {

import flash.display.Sprite;

[SWF(width="640", height="480", frameRate="60", backgroundColor="#ffffff")]
public class Main extends Sprite {
    public function Main () {
        try {
            testConsts();
            trace("Everything works!");
            this.stage.color = 0x00ff00;
        } catch (e :Error) {
            trace("Something broke:\n" + e);
            this.stage.color = 0xff0000;
        }
    }

    public static function assertEquals (a :Number, b :Number, name :String) :void {
        if (a != b) {
            throw new Error(name + " assertion failed: " + a + " != " + b);
        }
    }

    public static function testConsts () :void {
        var closure :Function = function () :void {
            // I'm a closure that does nothing, but my existence breaks const initialization on iOS
        };

        var outerVar :Number = 1;
        const outerConst :Number = 2;
        assertEquals(outerVar, 1, "outerVar");
        assertEquals(outerConst, 2, "outerConst");

        if (outerVar == 1) {
            var innerVar :Number = 3;
            const innerConst :Number = 4;
            assertEquals(innerVar, 3, "innerVar");

            // on iOS, this fails. innerConst gets initialized to 0.
            // Removing the closure from the function makes things work as expected.
            assertEquals(innerConst, 4, "innerConst");
        }
    }
}

}
