class Test {

	static function test(x,v:Dynamic,?vars : Dynamic) {
		var p = new hscript.Parser();
		var program = p.parseString(x);
		var interp = new hscript.Interp();
		if( vars != null )
			for( v in Reflect.fields(vars) )
				interp.variables.set(v,Reflect.field(vars,v));
		var ret : Dynamic = interp.execute(program);
		if( v != ret ) throw ret+" returned while "+v+" expected";
	}

	static function main() {
		test("0",0);
		test("0xFF",255);
		test("-123",-123);
		test("- 123",-123);
		test("1.546",1.546);
		test("'bla'","bla");
		test("null",null);
		test("true",true);
		test("false",false);
		test("1 == 2",false);
		test("1.3 == 1.3",true);
		test("5 > 3",true);
		test("0 < 0",false);
		test("-1 <= -1",true);
		test("1 + 2",3);
		test("'abc' + 55","abc55");
		test("'abc' + 'de'","abcde");
		test("-1 + 2",1);
		test("1 / 5",0.2);
		test("3 * 2 + 5",11);
		test("3 * (2 + 5)",21);
		test("3 * 2 // + 5 \n + 6",12);
		test("3 /* 2\n */ + 5",8);
		test("x",55,{ x : 55 });
		test("var y = 33; y",33);
		test("{ 1; 2; 3; }",3);
		test("{ var x = 0; } x",55,{ x : 55 });
		test("o.val",55,{ o : { val : 55 } });
		test("o.val",null,{ o : {} });
		test("var a = 1; a++",1);
		test("var a = 1; a++; a",2);
		test("var a = 1; ++a",2);
		test("var a = 1; a *= 3",3);
		test("add(1,2)",3,{ add : function(x,y) return x + y });
		test("a.push(5); a.pop() + a.pop()",8,{ a : [3] });
		test("if( true ) 1 else 2",1);
		test("if( false ) 1 else 2",2);
		test("var t = 0; for( x in [1,2,3] ) t += x; t",6);
		test("(function(a,b) return a + b)(4,5)",9);
		test("var y = 0; var add = function(a) y += a; add(5); add(3); y", 8);
		test("var a = [1,[2,[3,[4,null]]]]; var t = 0; while( a != null ) { t += a[0]; a = a[1]; }; t",10);
		test("var t = 0; for( x in 1...10 ) t += x; t",45);
		test("var t = 0; for( x in new IntIter(1,10) ) t +=x; t",45,{ IntIter : IntIter });
		test("var x = 1; try { var x = 66; throw 789; } catch( e : Dynamic ) e + x",790);
	}

}