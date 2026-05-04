package se.kth.project.DTO;


public class Instrument {

    private  int instrumentID;
    private  String instrumentKind;
    private  String instrumentBrand;

    public Instrument() {

    }

    public void setInstrumentID(int instrumentID) {
        this.instrumentID = instrumentID;
    }

    public void setInstrumentKind(String instrumentKind) {
        this.instrumentKind = instrumentKind;
    }

    public void setInstrumentBrand(String instrumentBrand) {
        this.instrumentBrand = instrumentBrand;
    }

    public int getInstrumentID() {
        return instrumentID;
    }

    public String getInstrumentKind() {
        return instrumentKind;
    }

    public String getInstrumentBrand() {
        return instrumentBrand;
    }
}
