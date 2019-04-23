//
//  paramTests.swift
//  rosswiftTests
//
//  Created by Thomas Gustafsson on 2018-10-30.
//

import XCTest
@testable import RosSwift
@testable import RosTime


class paramTests: XCTestCase {

    static var allTests = [
        ("testAllParamTypes",testAllParamTypes),
        ("testSetThenGetString",testSetThenGetString),
        ("testSetThenGetStringCached",testSetThenGetStringCached),
        ("testSetThenGetNamespaceCached", testSetThenGetNamespaceCached),
        ("testSetThenGetCString",testSetThenGetCString),
        ("testsetThenGetInt",testsetThenGetInt),
        ("testunknownParam",testunknownParam),
        ("testdeleteParam",testdeleteParam),
        ("testhasParam",testhasParam),
        ("testsetIntDoubleGetInt", testsetIntDoubleGetInt),
        ("testgetIntAsDouble",testgetIntAsDouble),
        ("testgetDoubleAsInt",testgetDoubleAsInt),
        ("testsearchParam",testsearchParam),
        ("testsearchParamNodeHandle",testsearchParamNodeHandle),
        ("testsearchParamNodeHandleWithRemapping",testsearchParamNodeHandleWithRemapping),
        ("testgetMissingXmlRpcValueParameterCachedTwice", testgetMissingXmlRpcValueParameterCachedTwice),
        ("testdoublePrecision",testdoublePrecision),
        ("testvectorStringParam",testvectorStringParam),
        ("testvectorDoubleParam",testvectorDoubleParam),
        ("testvectorFloatParam",testvectorFloatParam),
        ("testvectorIntParam",testvectorIntParam),
        ("testvectorBoolParam", testvectorBoolParam),
        ("testmapStringParam",testmapStringParam),
        ("testmapDoubleParam",testmapDoubleParam),
        ("testmapFloatParam",testmapFloatParam),
        ("testmapIntParam",testmapIntParam),
        ("testmapBoolParam",testmapBoolParam),
        ("testparamTemplateFunction",testparamTemplateFunction),
        ("testparamNodeHandleTemplateFunction",testparamNodeHandleTemplateFunction),
        ("testZgetParamNames",testZgetParamNames)

    ]


    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let _ = Ros.initialize(argv: &CommandLine.arguments, name: "paramTests")
        Ros.Param.set(key: "string", value: "test")
        Ros.Param.set(key: "int", value: Int(10))
        Ros.Param.set(key: "double", value: Double(10.5))
        Ros.Param.set(key: "bool", value: false)
        _ = Ros.Param.del(key: "/test_set_param_setThenGetStringCached")

    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        Ros.shutdown()
    }

    func testAllParamTypes() {
        var string_param = ""
        XCTAssert( Ros.Param.get( "string", &string_param ) )
        XCTAssert( string_param == "test" )

        var int_param = 0
        XCTAssert( Ros.Param.get( "int", &int_param ) )
        XCTAssert( int_param == 10 )

        var double_param = 0.0
        XCTAssert( Ros.Param.get( "double", &double_param ) )
        XCTAssertEqual( double_param, 10.5 )

        var bool_param = true
        XCTAssert( Ros.Param.get( "bool", &bool_param ) )
        XCTAssertFalse( bool_param )
    }

    func testSetThenGetString() {
        Ros.Param.set( key: "test_set_param", value: "asdf" )

        var param = ""
        XCTAssert( Ros.Param.get( "test_set_param", &param ) )
        XCTAssertEqual( "asdf", param )

        var v = XmlRpcValue()
        XCTAssert( Ros.Param.get("test_set_param", &v) )
        XCTAssertEqual(v, XmlRpcValue(str: "asdf") )
    }

    func testSetThenGetStringCached() {
        _ = Ros.Param.del(key: "test_set_param_setThenGetStringCached")
        var  param = ""
        XCTAssertFalse( Ros.Param.getCached( "test_set_param_setThenGetStringCached", &param) )

        Ros.Param.set( key: "test_set_param_setThenGetStringCached", value: "asdf" )
        XCTAssert( Ros.Param.getCached( "test_set_param_setThenGetStringCached", &param) )
        XCTAssertEqual( "asdf", param )
    }

    func testSetThenGetNamespaceCached()
    {
        _ = Ros.Param.del(key: "/test_set_param_setThenGetStringCached2")
        var stringParam = ""
        var structParam = XmlRpcValue()
        let ns = "test_set_param_setThenGetStringCached2"
        XCTAssertFalse(Ros.Param.getCached(ns, &stringParam))

        Ros.Param.set(key: ns, value: "a")
        XCTAssert(Ros.Param.getCached(ns, &stringParam))
        XCTAssertEqual("a", stringParam)

        Ros.Param.set(key: ns + "/foo", value: "b")
        XCTAssert(Ros.Param.getCached(ns + "/foo", &stringParam))
        XCTAssertEqual("b", stringParam)
        XCTAssert(Ros.Param.getCached(ns, &structParam))
        XCTAssert(structParam.hasMember("foo"))
        XCTAssertEqual("b", structParam["foo"]?.string)
    }

    func testSetThenGetCString()
    {
        Ros.Param.set( key: "test_set_param", value: "asdf" )
        var param = ""
        XCTAssert( Ros.Param.get( "test_set_param", &param ) )
        XCTAssertEqual( "asdf", param )
    }

    func testsetThenGetInt()
    {
        Ros.Param.set( key: "test_set_param", value: 42)
        var param = 0
        XCTAssert( Ros.Param.get( "test_set_param", &param ) )
        XCTAssertEqual( 42, param )
        var v = XmlRpcValue()
        XCTAssert(Ros.Param.get("test_set_param", &v))
        guard case .int = v.value else {
            XCTFail()
            return
        }
    }

    func testunknownParam()
    {
        var param = ""
        XCTAssertFalse( Ros.Param.get( "this_param_really_should_not_exist", &param ) )
    }

    func testdeleteParam()
    {
        _ = Ros.Param.set( key: "test_delete_param", value: "asdf" )
        _ = Ros.Param.del( key: "test_delete_param" )
        var param = ""
        XCTAssertFalse( Ros.Param.get( "test_delete_param", &param ) )
    }

    func testhasParam()
    {
        XCTAssert( Ros.Param.has( key: "string" ) )
    }

    func testsetIntDoubleGetInt()
    {
        Ros.Param.set(key: "test_set_int_as_double", value: 1)
        Ros.Param.set(key: "test_set_int_as_double", value: 3.0)

        var i = -1
        XCTAssert(Ros.Param.get("test_set_int_as_double", &i))
        XCTAssertEqual(3, i)
        var d = 0.0
        XCTAssert(Ros.Param.get("test_set_int_as_double", &d))
        XCTAssertEqual(3.0, d)
    }

    func testgetIntAsDouble()
    {
        Ros.Param.set(key: "int_param", value: 1)
        var d = 0.0
        XCTAssert(Ros.Param.get("int_param", &d))
        XCTAssertEqual(1.0, d)
    }

    func testgetDoubleAsInt()
    {
        Ros.Param.set(key: "double_param", value: 2.3)
        var i = -1
        XCTAssert(Ros.Param.get("double_param", &i))
        XCTAssertEqual(2, i)

        Ros.Param.set(key: "double_param", value: 3.8)
        i = -1
        XCTAssert(Ros.Param.get("double_param", &i))
        XCTAssertEqual(4, i)
    }

    func testsearchParam()
    {
        let ns = "/a/b/c/d/e/f"
        var result = ""

        Ros.Param.set(key: "/s_i", value: 1)
        XCTAssert(Ros.Param.search(ns: ns, key: "s_i", result: &result))
        XCTAssertEqual(result, "/s_i")
        XCTAssert(Ros.Param.del(key: "/s_i"))

        Ros.Param.set(key: "/a/b/s_i", value: 1)
        XCTAssert(Ros.Param.search(ns: ns, key: "s_i", result: &result))
        XCTAssertEqual(result, "/a/b/s_i")
        XCTAssert(Ros.Param.del(key: "/a/b/s_i"))

        Ros.Param.set(key: "/a/b/c/d/e/f/s_i", value: 1)
        XCTAssert(Ros.Param.search(ns: ns, key: "s_i", result: &result))
        XCTAssertEqual(result, "/a/b/c/d/e/f/s_i")
        XCTAssert(Ros.Param.del(key: "/a/b/c/d/e/f/s_i"))

        XCTAssertFalse(Ros.Param.search(ns: ns, key: "s_j", result: &result))
    }

    func testsearchParamNodeHandle()
    {
        guard let n = Ros.NodeHandle(ns: "/a/b/c/d/e/f") else {
            XCTFail()
            return
        }
        var result = ""

        n.set(parameter: "/s_i", value: 1)
        let ok = n.search(parameter: "s_i", result: &result)
        XCTAssert(ok)
        XCTAssertEqual(result, "/s_i")
        XCTAssert(n.delete(paramter: "/s_i"))

        n.set(parameter: "/a/b/s_i", value: 1)
        XCTAssert(n.search(parameter: "s_i", result: &result))
        XCTAssertEqual(result, "/a/b/s_i")
        XCTAssert(n.delete(paramter:"/a/b/s_i"))

        n.set(parameter: "/a/b/c/d/e/f/s_i", value: 1)
        XCTAssert(n.search(parameter: "s_i", result: &result))
        XCTAssertEqual(result, "/a/b/c/d/e/f/s_i")
        XCTAssert(n.delete(paramter:"/a/b/c/d/e/f/s_i"))

        XCTAssertFalse(n.search(parameter: "s_j", result: &result))
    }

    func testsearchParamNodeHandleWithRemapping()
    {
        _ = Ros.Param.del(key: "/s_b")
        let remappings = ["s_c":"s_b"]
        guard let n = Ros.NodeHandle(ns: "/a/b/c/d/e/f", remappings: remappings) else {
            XCTFail()
            return
        }
        var result = ""

        n.set(parameter: "/s_c", value: 1)
        XCTAssertFalse(n.search(parameter: "s_c", result: &result))
        n.set(parameter: "/s_b", value: 1)
        XCTAssert(n.search(parameter: "s_c", result: &result))
        print("RESULT \(result)")
    }

    func testgetMissingXmlRpcValueParameterCachedTwice()
    {
        var v = XmlRpcValue()
        XCTAssertFalse(Ros.Param.getCached("invalid_xmlrpcvalue_param", &v))
        XCTAssertFalse(Ros.Param.getCached("invalid_xmlrpcvalue_param", &v))
    }

    func testdoublePrecision()
    {
        Ros.Param.set(key: "bar", value: 0.123456789123456789)
        var d = 0.0
        XCTAssert(Ros.Param.get("bar", &d))
        XCTAssertEqual(d, 0.12345678912345678)
    }

    var vec_s = [String]()
    var vec_s2 = [String]()
    var vec_d = [Double]()
    var vec_d2 = [Double]()
    var vec_f = [Float32]()
    var vec_f2 = [Float32]()
    var vec_i = [Int]()
    var vec_i2 = [Int]()
    var vec_b = [Bool]()
    var vec_b2 = [Bool]()

    func testvectorStringParam()
    {
        let param_name = "v_param"


        vec_s = ["foo","bar","baz"]

        Ros.Param.set(key: param_name, value: vec_s)

        XCTAssertFalse(Ros.Param.get(param_name, &vec_d))
        XCTAssertFalse(Ros.Param.get(param_name, &vec_f))
        XCTAssertFalse(Ros.Param.get(param_name, &vec_i))
        XCTAssertFalse(Ros.Param.get(param_name, &vec_b))

        XCTAssert(Ros.Param.get(param_name, &vec_s2))

        XCTAssertEqual(vec_s.count, vec_s2.count)
        XCTAssertEqual(vec_s, vec_s2)

        // test empty vector
        vec_s.removeAll()
        Ros.Param.set(key: param_name, value: vec_s)
        XCTAssert(Ros.Param.get(param_name, &vec_s2))
        XCTAssertEqual(vec_s.count, vec_s2.count)
    }

    func testvectorDoubleParam()
    {
        let param_name = "vec_double_param"

        vec_d = [-0.123456789,3,3.01,7.01]

        Ros.Param.set(key: param_name, value: vec_d)

        XCTAssertFalse(Ros.Param.get(param_name, &vec_s))
        XCTAssert(Ros.Param.get(param_name, &vec_i))
        XCTAssert(Ros.Param.get(param_name, &vec_b))
        XCTAssert(Ros.Param.get(param_name, &vec_f))

        XCTAssert(Ros.Param.get(param_name, &vec_d2))

        XCTAssertEqual(vec_d.count, vec_d2.count)
        XCTAssertEqual(vec_d, vec_d2)
        XCTAssertEqual(vec_f, [-0.123456789,3,3.01,7.01])
        XCTAssertEqual(vec_i, [0,3,3,7])
        XCTAssertEqual(vec_b, [true,true,true,true])

    }

    func testvectorFloatParam()
    {
        let param_name = "vec_float_param"

        vec_f = [-0.25, 0.0, 3, 3.25]

        Ros.Param.set(key: param_name, value: vec_f)

        XCTAssertFalse(Ros.Param.get(param_name, &vec_s))
        XCTAssert(Ros.Param.get(param_name, &vec_i))
        XCTAssert(Ros.Param.get(param_name, &vec_b))
        XCTAssert(Ros.Param.get(param_name, &vec_d))

        XCTAssertEqual(vec_b,[true,false,true,true])
        XCTAssertEqual(vec_i, [0,0,3,3])
        XCTAssertEqual(vec_d, [-0.25, 0.0, 3, 3.25])

        XCTAssert(Ros.Param.get(param_name, &vec_f2))

        XCTAssertEqual(vec_f.count, vec_f2.count)
        XCTAssertEqual(vec_f, vec_f2)
    }

    func testvectorIntParam()
    {
        let param_name = "vec_int_param"

        vec_i = [-1, 0, 1337, 2]

        Ros.Param.set(key: param_name, value: vec_i)

        XCTAssertFalse(Ros.Param.get(param_name, &vec_s))
        XCTAssert(Ros.Param.get(param_name, &vec_d))
        XCTAssert(Ros.Param.get(param_name, &vec_f))
        XCTAssert(Ros.Param.get(param_name, &vec_b))

        XCTAssertEqual(vec_b,[true,false,true,true])
        XCTAssertEqual(vec_f,[-1,0,1337,2])
        XCTAssertEqual(vec_d,[-1,0,1337,2])

        XCTAssert(Ros.Param.get(param_name, &vec_i2))

        XCTAssertEqual(vec_i.count, vec_i2.count)
        XCTAssertEqual(vec_i, vec_i2)
    }

    func testvectorBoolParam()
    {
        let param_name = "vec_bool_param"

        vec_b = [true, false, true, true]

        Ros.Param.set(key: param_name, value: vec_b)

        XCTAssertFalse(Ros.Param.get(param_name, &vec_s))
        XCTAssert(Ros.Param.get(param_name, &vec_d))
        XCTAssert(Ros.Param.get(param_name, &vec_f))
        XCTAssert(Ros.Param.get(param_name, &vec_i))

        XCTAssertEqual(vec_i,[1,0,1,1])
        XCTAssertEqual(vec_d,[1,0,1,1])
        XCTAssertEqual(vec_f,[1,0,1,1])


        XCTAssert(Ros.Param.get(param_name, &vec_b2))

        XCTAssertEqual(vec_b.count, vec_b2.count)
        XCTAssertEqual(vec_b, vec_b2)
    }

    var map_s = [String:String]()
    var map_s2 = [String:String]()
    var map_d = [String:Double]()
    var map_d2 = [String:Double]()
    var map_f = [String:Float32]()
    var map_f2 = [String:Float32]()
    var map_i = [String:Int]()
    var map_i2 = [String:Int]()
    var map_b = [String:Bool]()
    var map_b2 = [String:Bool]()

    func testmapStringParam()
    {
        let param_name = "map_str_param"

        map_s = ["a": "apple", "b": "blueberry", "c": "carrot"]

        Ros.Param.set(key: param_name, value: map_s)

        XCTAssertFalse(Ros.Param.get(param_name, &map_d))
        XCTAssertFalse(Ros.Param.get(param_name, &map_f))
        XCTAssertFalse(Ros.Param.get(param_name, &map_i))
        XCTAssertFalse(Ros.Param.get(param_name, &map_b))

        XCTAssert(Ros.Param.get(param_name, &map_s2))

        XCTAssertEqual(map_s.count, map_s2.count)
        XCTAssertEqual(map_s, map_s2)
    }

    func testmapDoubleParam()
    {
        let param_name = "map_double_param"

        map_d = ["a":0.0,"b":-0.123456789,"c":123456789]

        Ros.Param.set(key: param_name, value: map_d)

        XCTAssertFalse(Ros.Param.get(param_name, &map_s))
        XCTAssert(Ros.Param.get(param_name, &map_f))
        XCTAssert(Ros.Param.get(param_name, &map_i))
        XCTAssert(Ros.Param.get(param_name, &map_b))
        XCTAssert(Ros.Param.get(param_name, &map_d2))

        XCTAssertEqual(map_f, ["a":0.0,"b":-0.123456789,"c":123456789])
        XCTAssertEqual(map_i, ["a":0,"b":0,"c":123456789])
        XCTAssertEqual(map_b, ["a":false,"b":true,"c":true])

        XCTAssertEqual(map_d.count, map_d2.count)
        XCTAssertEqual(map_d, map_d2)
    }

    func testmapFloatParam()
    {
        let param_name = "map_float_param"

        map_f = ["a": 0.0, "b":-0.25,"c":1234567]

        Ros.Param.set(key: param_name, value: map_f)

        XCTAssertFalse(Ros.Param.get(param_name, &map_s))
        XCTAssert(Ros.Param.get(param_name, &map_d))
        XCTAssert(Ros.Param.get(param_name, &map_i))
        XCTAssert(Ros.Param.get(param_name, &map_b))

        XCTAssertEqual(map_d, ["a":0.0,"b":-0.25,"c":1234567])
        XCTAssertEqual(map_i, ["a":0,"b":0,"c":1234567])
        XCTAssertEqual(map_b, ["a":false,"b":true,"c":true])

        XCTAssert(Ros.Param.get(param_name, &map_f2))

        XCTAssertEqual(map_f.count, map_f2.count)
        XCTAssertEqual(map_f, map_f2)
    }

    func testmapIntParam()
    {
        let param_name = "map_int_param"

        map_i = ["a":0, "b":-1, "c":1337]

        Ros.Param.set(key: param_name, value: map_i)

        XCTAssertFalse(Ros.Param.get(param_name, &map_s))
        XCTAssert(Ros.Param.get(param_name, &map_d))
        XCTAssert(Ros.Param.get(param_name, &map_f))
        XCTAssert(Ros.Param.get(param_name, &map_b))

        XCTAssertEqual(map_f, ["a":0.0,"b":-1,"c":1337])
        XCTAssertEqual(map_d, ["a":0,"b":-1,"c":1337])
        XCTAssertEqual(map_b, ["a":false,"b":true,"c":true])

        XCTAssert(Ros.Param.get(param_name, &map_i2))

        XCTAssertEqual(map_i.count, map_i2.count)
        XCTAssertEqual(map_i, map_i2)
    }

    func testmapBoolParam()
    {
        let param_name = "map_bool_param"

        map_b = ["a":true, "b":false, "c":true]

        Ros.Param.set(key: param_name, value: map_b)

        XCTAssertFalse(Ros.Param.get(param_name, &map_s))
        XCTAssert(Ros.Param.get(param_name, &map_d))
        XCTAssert(Ros.Param.get(param_name, &map_f))
        XCTAssert(Ros.Param.get(param_name, &map_i))

        XCTAssertEqual(map_i, ["a":1,"b":0, "c":1])
        XCTAssertEqual(map_f, ["a":1,"b":0, "c":1])
        XCTAssertEqual(map_d, ["a":1,"b":0, "c":1])

        XCTAssert(Ros.Param.get(param_name, &map_b2))

        XCTAssertEqual(map_b.count, map_b2.count)
        XCTAssertEqual(map_b, map_b2)
    }

    func testparamTemplateFunction()
    {
        XCTAssertEqual( Ros.Param.param( name: "string", defaultValue: "" ), "test" )
        XCTAssertEqual( Ros.Param.param( name: "gnirts", defaultValue: "test" ), "test" )

        XCTAssertEqual( Ros.Param.param( name: "int", defaultValue: 0 ), 10 )
        XCTAssertEqual( Ros.Param.param( name: "tni", defaultValue: 10 ), 10 )

        XCTAssertEqual( Ros.Param.param( name: "double", defaultValue: 0.0 ), 10.5 )
        XCTAssertEqual( Ros.Param.param( name: "elbuod", defaultValue: 10.5 ), 10.5 )

        XCTAssertEqual( Ros.Param.param( name: "bool", defaultValue: true ), false )
        XCTAssertEqual( Ros.Param.param( name: "loob", defaultValue: true ), true )
    }

    func testparamNodeHandleTemplateFunction()
    {
        let nh = Ros.NodeHandle()

        XCTAssertEqual( nh.param( name: "string", defaultValue: "" ), "test" )
        XCTAssertEqual( nh.param( name: "gnirts", defaultValue: "test" ), "test" )

        XCTAssertEqual( nh.param( name: "int", defaultValue: 0 ), 10 )
        XCTAssertEqual( nh.param( name: "tni", defaultValue: 10 ), 10 )

        XCTAssertEqual( nh.param( name: "double", defaultValue: 0.0 ), 10.5 )
        XCTAssertEqual( nh.param( name: "elbuod", defaultValue: 10.5 ), 10.5 )

        XCTAssertEqual( nh.param( name: "bool", defaultValue: true ), false )
        XCTAssertEqual( nh.param( name: "loob", defaultValue: true ), true )
    }

    // should run last, tests runs in alphabetical order (unless random order is selected)
    func testZgetParamNames() {
        var test_params = [String]()
        let b = Ros.Param.getParamNames(keys: &test_params)


        XCTAssert(b)
        XCTAssertLessThan(10, test_params.count)
    }


}
