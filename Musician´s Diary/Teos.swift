//
//  Teos.swift
//  MusicDiaryTest
//
//  Created by Mihkel Märtin on 30/12/2017.
//  Copyright © 2017 Joosep Teemaa. All rights reserved.
//

import Foundation
import UIKit

/**
 * Created by mihkel on 2.05.2016.
 */



public class Teos: Comparable{
    
    
    var id: Int!;
    var nimi: String!;
    var autor:String?;
    var kommentaar: String?;
    var hinnang: CShort?;
    var lisatudpaevikusse: Date?;
    var kasutusviis: CShort?;
    
    var harjutuskorrad = [Harjutuskord]()
    var harjutuskorradmap = [Int: Harjutuskord]()
    
    public static func ==(lhs: Teos, rhs: Teos) -> Bool {
        if lhs.nimi != rhs.nimi{
            return lhs.nimi == rhs.nimi
        }
    }
    public static func < (lhs: Teos, rhs: Teos) -> Bool {
        if lhs.nimi != rhs.nimi{
            return lhs.nimi < rhs.nimi
        }
    }
    public class Teosekirje {
        public static let TABLE_NAME = "Teos";
        public static let COLUMN_NAME_NIMI = "nimi";
        public static let COLUMN_NAME_AUTOR = "autor";
        public static let COLUMN_NAME_KOMMENTAAR = "kommentaar";
        public static let COLUMN_NAME_HINNANG = "hinnang";
        public static let COLUMN_NAME_LISATUDPAEVIKUSSE = "lisatudpaevikusse";
        public static let COLUMN_NAME_KASUTUSVIIS = "kasutusviis";
    }
    
    public init(){
        setKasutusviis(kasutusviis: 1);
        setLisatudpaevikusse(lisatudpaevikusse : Date());
    }
    
    private func LoadHarjustuskorrad() {
        var harjutuskorrad = [Harjutuskord]();
        var harjutuskorradmap = [Int:Harjutuskord]();
        //PilliPaevikDatabase mPPManager = new PilliPaevikDatabase(context);
        mPPManager.getAllHarjutuskorrad(this.id, this.Harjustuskorrad, this.Harjutuskorradmap);
    }
    
    public List<HarjutusKord> getHarjustuskorrad(Context context) {
        
        if(Harjustuskorrad == null)
        LoadHarjustuskorrad(context);
        return Harjustuskorrad;
    }
    
    public HashMap<Integer, HarjutusKord> getHarjutuskorradmap(Context context) {
        
        if(Harjutuskorradmap == null)
        LoadHarjustuskorrad(context);
        return Harjutuskorradmap;
    }
    
    public void EemaldaHarjutuskorradHulkadest() {
        if(Harjustuskorrad != null)
        Harjustuskorrad.clear();
        if(Harjutuskorradmap != null)
        Harjutuskorradmap.clear();
    }
    
    public void EemaldaHarjutusHulkadest(int harjutusid) {
        
        HarjutusKord harjutus = null;
        if(Harjutuskorradmap != null) {
            harjutus = Harjutuskorradmap.get(harjutusid);
            Harjutuskorradmap.remove(harjutusid);
            if(BuildConfig.DEBUG) Log.d("Teos","Eemaldasinme Harjutuse Mapist. Harjutus:"+ harjutusid);
        }
        if(Harjustuskorrad != null && harjutus != null){
            Harjustuskorrad.remove(harjutus);
            if(BuildConfig.DEBUG) Log.d("Teos","Eemaldasinme Harjutuse Setist. Harjutus:"+ harjutusid);
        }
        
    }
    
    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }
    
    public String getNimi() {
        return nimi;
    }
    public void setNimi(String nimi) {
        this.nimi = nimi;
    }
    
    public String getAutor() {
        return autor;
    }
    public void setAutor(String autor) {
        this.autor = autor;
    }
    
    public String getKommentaar() {
        return kommentaar;
    }
    public void setKommentaar(String kommentaar) {
        this.kommentaar = kommentaar;
    }
    
    public short getHinnang() {
        return hinnang;
    }
    public void setHinnang(short hinnang) {
        this.hinnang = hinnang;
    }
    
    public Date getLisatudpaevikusse() {
        return lisatudpaevikusse;
    }
    public func setLisatudpaevikusse(lisatudpaevikusse : Date) {
        self.lisatudpaevikusse = lisatudpaevikusse;
    }
    
    public short getKasutusviis() {
        return kasutusviis;
    }
    public func setKasutusviis(kasutusviis : CShort) {
        self.kasutusviis = kasutusviis;
    }
    
    public void Salvesta(Context context){
        PilliPaevikDatabase mPPManager = new PilliPaevikDatabase(context);
        mPPManager.SalvestaTeos(this);
    }
    public void Kustuta(Context context){
        KustutaHarjutusteFailid(context);
        PilliPaevikDatabase mPPManager = new PilliPaevikDatabase(context);
        mPPManager.KustutaTeos(getId());
    }
    
    public void KustutaHarjutusteFailid(Context context){
        List<HarjutusKord> pHarjutused = getHarjustuskorrad(context);
        for(HarjutusKord pH : pHarjutused) {
            pH.KustutaFailid(context);
        }
    }
    
    
    public String toString(){
        return "ID:" + id + "Nimi:" + this.nimi + " Autor:" + this.autor +
            " Kommentaar:" + this.kommentaar + " Hinnang:" + this.hinnang +
            " Lisatud:" + this.lisatudpaevikusse + " Kasutusviis:" + this.kasutusviis;
    }
}
