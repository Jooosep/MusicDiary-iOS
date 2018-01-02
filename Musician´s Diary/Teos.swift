//
//  Teos.swift
//  MusicDiaryTest
//
//  Created by Mihkel Märtin on 30/12/2017.
//  Copyright © 2017 Joosep Teemaa. All rights reserved.
//

import Foundation

/**
 * Created by mihkel on 2.05.2016.
 */

public class Harjutuskord{}

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
        public static var TABLE_NAME = "Teos";
        public static var COLUMN_NAME_NIMI = "nimi";
        public static var COLUMN_NAME_AUTOR = "autor";
        public static var COLUMN_NAME_KOMMENTAAR = "kommentaar";
        public static var COLUMN_NAME_HINNANG = "hinnang";
        public static var COLUMN_NAME_LISATUDPAEVIKUSSE = "lisatudpaevikusse";
        public static var COLUMN_NAME_KASUTUSVIIS = "kasutusviis";
    }
    
    public init(){
        setKasutusviis((short) 1);
        setLisatudpaevikusse(Calendar.getInstance().getTime());
    }
    
    private void LoadHarjustuskorrad(Context context) {
        Harjustuskorrad = new ArrayList<HarjutusKord>();
        Harjutuskorradmap = new HashMap<Integer, HarjutusKord>();
        PilliPaevikDatabase mPPManager = new PilliPaevikDatabase(context);
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
    public void setLisatudpaevikusse(Date lisatudpaevikusse) {
        this.lisatudpaevikusse = lisatudpaevikusse;
    }
    
    public short getKasutusviis() {
        return kasutusviis;
    }
    public void setKasutusviis(short kasutusviis) {
        this.kasutusviis = kasutusviis;
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
