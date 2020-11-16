package domain;

public class RequestDetails {
    private double x;
    private String y;
    private int r;
    private boolean isEntry;

    public RequestDetails() {
    }

    public RequestDetails(double x, String y, int r, boolean isEntry) {
        this.x = x;
        this.y = y;
        this.r = r;
        this.isEntry = isEntry;
    }

    public double getX() {
        return x;
    }

    public void setX(double x) {
        this.x = x;
    }

    public String getY() {
        return y;
    }

    public void setY(String y) {
        this.y = y;
    }

    public int getR() {
        return r;
    }

    public void setR(int r) {
        this.r = r;
    }

    public boolean isEntry() {
        return isEntry;
    }

    public void setEntry(boolean entry) {
        isEntry = entry;
    }
}
