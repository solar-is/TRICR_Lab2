import domain.RequestDetails;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import static java.lang.Math.sqrt;

public class AreaCheckServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String x = req.getParameter("x");
        String yVal = req.getParameter("yVal");
        String r = req.getParameter("r");

        double xReal = 0d, yReal = 0d, rReal = 0d;

        boolean parsedSuccessfully = true;

        try {
            xReal = Double.parseDouble(x);
            yReal = Double.parseDouble(yVal);
            rReal = Double.parseDouble(r);
        } catch (NumberFormatException e) {
            parsedSuccessfully = false;
        }

        String onlyDefaultValidation = req.getParameter("onlyDefaultValidation");

        boolean isValid = isValid(xReal, yReal, rReal);

        if ((onlyDefaultValidation != null && !parsedSuccessfully) ||
                (onlyDefaultValidation == null && (!parsedSuccessfully || !isValid))){
            req.getRequestDispatcher("/areaCheck.jsp").forward(req, resp);
        }
        boolean isEntry = isEntry(xReal, yReal, rReal);

        RequestDetails requestDetails = new RequestDetails(xReal, yReal, (int) rReal, isEntry);

        HttpSession session = req.getSession();
        Object entriesObject = session.getAttribute("entries");
        List<RequestDetails> entries;
        if (entriesObject != null) {
            entries = (List<RequestDetails>) entriesObject;
        } else {
            entries = new ArrayList<>();
        }
        entries.add(requestDetails);
        session.setAttribute("entries", entries);

        req.setAttribute("requestDetails", requestDetails);
        req.getRequestDispatcher("areaCheck.jsp").forward(req, resp);
    }

    private static boolean isValid(double x, double y, double r) {
        return (x >= -2 && x <= 2 && y >= -5 && y <= 5 && r >= 1 && r <= 5);
    }

    private static boolean isEntry(double x, double y, double r) {
        return (x <= 0 && y >= 0 && y <= r / 2 && x >= -r)
                || (x >= 0 && y <= 0 && x <= r && y >= 0.5 * (x - r))
                || (x <= 0 && y <= 0 && x >= -r && y >= -(sqrt(r - x) * sqrt(r + x)));
    }

}
