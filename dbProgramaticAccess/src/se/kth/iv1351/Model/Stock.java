package se.kth.project.Model;

import se.kth.project.DTO.Instrument;
import se.kth.project.DTO.StockInstruments;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 * Here where the instruments id, their rental fee and the number of existing instruments in the stock.
 */
public class Stock {
    private static Connection connection;
    private static String queryInstrument ="SELECT public.instrument.id, public.instrument.kind, public.instrument.brand FROM public.instrument";
    private static String queryStock ="SELECT * FROM public.stock ORDER BY instrument_id";

    public Stock(Connection connection) {
        Stock.connection = connection;
    }

    /**
     * @return all the instrument details as a list
     * @throws SQLException in unexpected cases while running the SQL queries.
     */
    public Instrument[] getInstrumentsDetails() throws SQLException, DatabaseException {
        Statement statement = connection.createStatement();
        Instrument[] instruments = new Instrument[10];
        try {
            ResultSet resultQueryInstrument = statement.executeQuery(queryInstrument);
            connection.commit();
            int instrumentNr = 0;
            while (resultQueryInstrument.next()) {
                int instrumentId = Integer.parseInt(resultQueryInstrument.getString(1));
                String instrumentKind =  resultQueryInstrument.getString(2);
                String instrumentBrand = resultQueryInstrument.getString(3);
                Instrument currentInstrument = new Instrument();
                currentInstrument.setInstrumentID(instrumentId);
                currentInstrument.setInstrumentKind(instrumentKind);
                currentInstrument.setInstrumentBrand(instrumentBrand);
                instruments[instrumentNr] = currentInstrument;
                instrumentNr++;
            }
            return instruments;
        }catch (Exception e ) {
            connection.rollback();
            throw new DatabaseException("Something went wrong, " + e.getMessage());
        }
    }

    /**
     * @return the availableInstruments as a lit of StockInstruments.
     * @throws SQLException in unexpected cases while running the SQL queries.
     */
    public StockInstruments[] getAvailableInstruments(StringBuilder returnedListAsString) throws SQLException, DatabaseException {
        //instrumentId, amount, rentalFee, amountRentedInstruments;
        List<StockInstruments> stockInstrumentsQueue = new ArrayList<StockInstruments>();
        try {
            if( connection != null)
            {
                Statement statement = connection.createStatement();
                ResultSet resultQueryInstrument = statement.executeQuery(queryInstrument);
                ResultSet resultQueryStock = statement.executeQuery(queryStock);
                connection.commit();

                returnedListAsString.append(String.format("%-13s%-13s%-13s%-13s\n","ID","Kind","Brand","Rental Price")) ;
                while (resultQueryInstrument.next())
                {
                    StockInstruments currentStockInstrument = new StockInstruments();
                    if(resultQueryStock.next())
                    {
                        int remainingInstruments = Integer.parseInt(resultQueryStock.getString(2)) - Integer.parseInt(resultQueryStock.getString(4));
                        if(remainingInstruments != 0)
                        {
                            currentStockInstrument.setInstrumentId(Integer.parseInt(resultQueryStock.getString(1)));
                            currentStockInstrument.setAmount(Integer.parseInt(resultQueryStock.getString(2)));
                            currentStockInstrument.setRentalFee(Integer.parseInt(resultQueryStock.getString(3)));
                            currentStockInstrument.setAmountRentedInstruments(Integer.parseInt(resultQueryStock.getString(4)));
                            stockInstrumentsQueue.add(currentStockInstrument);

                            returnedListAsString.append(String.format("%-12s ", resultQueryInstrument.getString(1)));
                            for (int i = 2; i < 4; i++)
                            {
                                returnedListAsString.append(String.format("%-12s ", resultQueryInstrument.getString(i)));
                            }
                            returnedListAsString.append(String.format("%-12s ",resultQueryStock.getString(3)));
                            returnedListAsString.append( "\n");
                        }
                    }
                }
                return stockInstrumentsQueue.toArray(new StockInstruments[0]);
            }
        }catch (Exception e ) {
            connection.rollback();
            throw new DatabaseException("Something went wrong, " + e.getMessage());
        }
        return null;
    }
}
