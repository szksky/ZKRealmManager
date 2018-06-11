//
//  ViewController.swift
//  ZKRealmManager
//
//  Created by shizhankun on 2018/6/12.
//  Copyright © 2018年 szk. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print("\(ZKRealmManager.shared())")
        
        //MARK: clear
        
        //        // 删除指定列表数据
        //        ZKRealmManager.shared().realmDeleteTypeList(object: Person.self)
        //删除当前数据库所有数据
        ZKRealmManager.shared().realmDeleteAll()
        
        //MARK: config
        // 切换数据库 ZKRealmManager.shared().configRealm(realmId: "100")提供了切换数据库的功能
        // 用于退出登录等场景一个用户对应一个数据库，防止数据混乱
        //        print("default data path \(String(describing: ZKRealmManager.shared().realm.configuration.fileURL?.absoluteString))")
        //        ZKRealmManager.shared().configRealm(realmId: "100")
        //        print("default data path \(String(describing: ZKRealmManager.shared().realm.configuration.fileURL?.absoluteString))")
        let persons:Results =  ZKRealmManager.shared()
            .realmGet().objects(Person.self)
        
        //MARK: add  添加测试数据
        if persons.count == 0 {
            
            var perA = Array<Person>()
            for i  in 1...100 {
                let p1 = Person()
                p1.id = i
                p1.name = "zhangsan" + "\(i)"
                p1.desc = "desc" + "\(i)"
                
                let dog = Dog()
                dog.id = i
                dog.name = "dog" + "\(i)"
                p1.dog = dog
                perA.append(p1)
                //添加单个
                ZKRealmManager.shared().realmAdd(object: p1)
                
            }
            //添加多个
            //            ZKRealmManager.shared().realmAdds(objects: perA)
            
        }
        //上面添加成功这里就是100
        print("person list count \(persons.count)")
        
        //MARK: delete
        
        //删除一个
        ZKRealmManager.shared().realmDelete(object: persons.first!)
        print("person list count \(persons.count)")
        
        //删除多个
        let personsQ1:Array<Person> = ZKRealmManager.shared().realmQueryWithParameters(object: Person.self, predicate: NSPredicate(format: "id < 11")) as! Array<Person>
        if personsQ1.count > 0 {
            ZKRealmManager.shared().realmDeletes(objects: personsQ1)
            print("person list count \(persons.count)")
        }
        
        //条件删除
        ZKRealmManager.shared().realmDeletesWithPredicate(object: Person.self, predicate: NSPredicate(format: "id > 90"))
        print("person list count \(persons.count)")
        
        //删除该类型所有
        //        ZKRealmManager.shared().realmDeleteTypeList(object: Person.self)
        //        print("person list count \(persons.count)")
        
        
        
        //MARK: update  更新数据
        //        print("person count \(persons.count)")
        let personFirst = persons.first
        
        //这样修改必须有主键
        //修改单个 1
        let personTmp = Person()
        personTmp.id = (personFirst?.id)!
        personTmp.name = "zhangsanChange1"
        //        personTmp.desc = "desc80"
        ZKRealmManager.shared().realmUpdte(object: personTmp)
        print("person name is \(String(describing: persons.first!.name)) \(String(describing: persons.first!.desc))")
        print("person count \(persons.count)")
        
        //修改单个2
        //        //不可以这样修改，修改realm内容需要开启事务，直接修改会崩溃
        //        personFirst!.name = "zhangsanChange"
        
        //开启事务修改，修改结果直接同步到本地硬盘
        //        try! ZKRealmManager.shared().realmGet().write {
        //            personFirst!.name = "zhangsanChange"
        //        }
        
        print("person name is \(String(describing: persons.first!.name))")
        
        ZKRealmManager.shared().realmUpdateWithTranstion { (isExcute) in
            personFirst!.name = "zhangsanChange"
        }
        
        print("person name is \(String(describing: persons.first!.name))")
        
        //修改多个
        var personsA2:Array<Object> = Array()
        for index in 0...10 {
            let personTmp = Person()
            personTmp.id = 70 + index
            personTmp.name = "zhangsanChange" + "\(index)"
            personsA2.append(personTmp)
        }
        
        ZKRealmManager.shared().realmUpdtes(objects: personsA2)
        
        for p in persons {
            print("------->\(p.name) id \(p.id)")
        }
        
        print("\(String(describing: persons.last?.name)) \(String(describing: persons.last?.id)) \(String(describing: persons.last?.desc))")
        
        //MARK: quary  查询
        
        //查询指定类型类型的数据
        let qA1:Array<Person> = ZKRealmManager.shared().realmQueryWith(object: Person.self) as! Array<Person>
        for p in qA1 {
            print("------->\(p.name) id \(p.id)")
        }
        print("\(qA1.count)")
        
        //条件查询指定类型数据
        let qA2:Array<Person> = ZKRealmManager.shared().realmQueryWithParameters(object: Person.self, predicate: NSPredicate(format: "id > 70")) as! Array<Person>
        for p in qA2 {
            print("------->\(p.name) id \(p.id)")
        }
        print("\(qA2.count)")
        
        //分页查询指定类型数据
        let qA3:Array<Person> = ZKRealmManager.shared().realmQueryWithParametersPage(object: Person.self, fromIndex: 7, pageSize: 5) as! Array<Person>
        for p in qA3 {
            print("------->\(p.name) id \(p.id)")
        }
        print("\(qA3.count)")
        
        //条件查排序询指定类型数据
        let qA4:Array<Person> = ZKRealmManager.shared().realmQueryWithParametersAndSorted(object: Person.self, predicate: NSPredicate(format: "id > 60"), sortedKey: "id", isAssending: false) as! Array<Person>
        for p in qA4 {
            print("------->\(p.name)")
        }
        print("\(qA4.count)")
        
        //条件分页查排序询指定类型数据
        let qA5:Array<Person> = ZKRealmManager.shared().realmQueryWithParametersAndSortedAndPaged(object: Person.self, predicate: NSPredicate(format: "id > 40"), sortedKey: "id", isAssending: true, fromIndex: 2, pageSize: 10) as! Array<Person>
        for p in qA5 {
            print("------->\(p.name) id \(p.id)")
        }
        print("\(qA4.count)")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

