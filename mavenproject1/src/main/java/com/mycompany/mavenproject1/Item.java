package com.mycompany.mavenproject1;

public abstract class Item {

    //Dessa hade också kunnat vara protected istället för private så de är öppna för subklasserna
    private int itemID;
    private int libraryID;
    private String title;

    //konstruktor
    public Item (int itemID, int libraryID, String title){
        this.itemID = itemID;
        this.libraryID = libraryID;
        this.title = title;
    }


    public int getItemID(){
        return itemID;
    }
    public int getLibraryID(){
        return libraryID;
    }
    public String getTitle(){
        return title;
    }


    public void setItemID(int itemID){
        this.itemID = itemID;
    }
    public void setLibraryID(int libraryID){
        this.libraryID = libraryID;
    }
    public void setTitle(String title){
        this.title = title;
    }



}
