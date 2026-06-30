package controller.invoice;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import dto.InvoiceItemDTO;

@WebServlet(name = "InvoicePreviewServlet", urlPatterns = {"/invoice/preview"})
public class InvoicePreviewServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String[] prodIds = request.getParameterValues("productId");
            String[] prodNames = request.getParameterValues("productName");
            String[] units = request.getParameterValues("unit");
            String[] quantities = request.getParameterValues("quantity");
            String[] sellingPrices = request.getParameterValues("sellingPrice");
            String[] discountPercents = request.getParameterValues("discountPercent");
            String[] taxPercents = request.getParameterValues("taxPercent");
            String[] lineTaxes = request.getParameterValues("lineTax");

            List<InvoiceItemDTO> orderDetails = new ArrayList<>();

            if (prodIds != null) {
                for (int i = 0; i < prodIds.length; i++) {
                    int productId = Integer.parseInt(prodIds[i]);
                    String productName = prodNames[i];
                    String unit = units[i];
                    int quantity = 0;
                    if (quantities != null && i < quantities.length && quantities[i] != null && !quantities[i].isEmpty()) {
                        try {
                            quantity = (int) Double.parseDouble(cleanNumberString(quantities[i]));
                        } catch (NumberFormatException e) {
                            quantity = 0;
                        }
                    }
                    double sellingPrice = 0.0;
                    if (sellingPrices != null && i < sellingPrices.length && sellingPrices[i] != null && !sellingPrices[i].isEmpty()) {
                        try {
                            sellingPrice = Double.parseDouble(cleanNumberString(sellingPrices[i]));
                        } catch (NumberFormatException e) {
                            sellingPrice = 0.0;
                        }
                    }
                    double discountPercent = 0.0;
                    if (discountPercents != null && i < discountPercents.length && discountPercents[i] != null && !discountPercents[i].isEmpty()) {
                        try {
                            discountPercent = Double.parseDouble(discountPercents[i].replace("%", "").trim());
                        } catch (NumberFormatException e) {
                            discountPercent = 0.0;
                        }
                    }
                    double taxPercent = 0.0;
                    if (taxPercents != null && i < taxPercents.length && taxPercents[i] != null && !taxPercents[i].isEmpty()) {
                        try {
                            taxPercent = Double.parseDouble(taxPercents[i].replace("%", "").trim());
                        } catch (NumberFormatException e) {
                            taxPercent = 0.0;
                        }
                    }

                    double lineAmount = quantity * sellingPrice;
                    double lineDiscount = lineAmount * (discountPercent / 100.0);
                    double lineTax = 0.0;
                    if (lineTaxes != null && i < lineTaxes.length && lineTaxes[i] != null && !lineTaxes[i].isEmpty()) {
                        try {
                            lineTax = Double.parseDouble(cleanNumberString(lineTaxes[i]));
                        } catch (NumberFormatException e) {
                            lineTax = (lineAmount - lineDiscount) * (taxPercent / 100.0);
                        }
                    } else {
                        lineTax = (lineAmount - lineDiscount) * (taxPercent / 100.0);
                    }

                    InvoiceItemDTO item = new InvoiceItemDTO(
                        productId, productName, unit, quantity, sellingPrice,
                        discountPercent, taxPercent, lineDiscount, lineTax
                    );
                    orderDetails.add(item);
                }
            }
            request.setAttribute("orderDetails", orderDetails);
            
            String invoiceType = request.getParameter("invoiceType");
            String invoiceSymbol = request.getParameter("invoiceSymbol");
            String invoiceNo = request.getParameter("invoiceNo");
            String issueDate = request.getParameter("issueDate");
            String invoiceStatus = request.getParameter("invoiceStatus");

            if (invoiceStatus == null || "UNRELEASED".equals(invoiceStatus) || invoiceNo == null || "0".equals(invoiceNo) || invoiceNo.startsWith("DFT")) {
                invoiceNo = "Not assigned (Auto-generated)";
                issueDate = "Auto-retrieved upon release";
            }

            String sellerName = request.getParameter("sellerName");
            String sellerTaxCode = request.getParameter("sellerTaxCode");
            String sellerAddress = request.getParameter("sellerAddress");
            String sellerPhone = request.getParameter("sellerPhone");

            String buyerName = request.getParameter("buyerName");
            String buyerTaxCode = request.getParameter("buyerTaxCode");
            String buyerAddress = request.getParameter("buyerAddress");
            String buyerPhone = request.getParameter("buyerPhone");

            String subTotalRaw = request.getParameter("subTotal");
            String discountTotalRaw = request.getParameter("discountTotal");
            String taxAmountRaw = request.getParameter("taxAmount");
            String totalAmountRaw = request.getParameter("totalAmount");

            BigDecimal subTotal = (subTotalRaw != null && !subTotalRaw.isEmpty()) ? new BigDecimal(cleanNumberString(subTotalRaw)) : BigDecimal.ZERO;
            BigDecimal discountTotal = (discountTotalRaw != null && !discountTotalRaw.isEmpty()) ? new BigDecimal(cleanNumberString(discountTotalRaw)) : BigDecimal.ZERO;
            BigDecimal taxAmount = (taxAmountRaw != null && !taxAmountRaw.isEmpty()) ? new BigDecimal(cleanNumberString(taxAmountRaw)) : BigDecimal.ZERO;
            BigDecimal totalAmount = (totalAmountRaw != null && !totalAmountRaw.isEmpty()) ? new BigDecimal(cleanNumberString(totalAmountRaw)) : BigDecimal.ZERO;

            String amountInWords = convertNumberToWords(totalAmount.longValue());

            request.setAttribute("invoiceType", invoiceType);
            request.setAttribute("invoiceSymbol", invoiceSymbol);
            request.setAttribute("invoiceNo", invoiceNo);
            request.setAttribute("issueDate", issueDate);
            
            request.setAttribute("sellerName", sellerName);
            request.setAttribute("sellerTaxCode", sellerTaxCode);
            request.setAttribute("sellerAddress", sellerAddress);
            request.setAttribute("sellerPhone", sellerPhone);
            
            request.setAttribute("buyerName", buyerName);
            request.setAttribute("buyerTaxCode", buyerTaxCode);
            request.setAttribute("buyerAddress", buyerAddress);
            request.setAttribute("buyerPhone", buyerPhone);
            
            request.setAttribute("subTotal", subTotal);
            request.setAttribute("discountTotal", discountTotal);
            request.setAttribute("taxAmount", taxAmount);
            request.setAttribute("totalAmount", totalAmount);
            request.setAttribute("amountInWords", amountInWords);

            // 4. Forward sang template.jsp
            request.getRequestDispatcher("/views/invoice/template.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error rendering preview: " + e.getMessage());
        }
    }

    private String convertNumberToWords(long number) {
        if (number == 0) return "Không đồng";
        String[] units = {"", "một", "hai", "ba", "bốn", "năm", "sáu", "bảy", "tám", "chín"};
        String rawWords = formatWords(number, units).trim();
        if (rawWords.isEmpty()) return "Không đồng";
        // Capitalize the first letter
        return rawWords.substring(0, 1).toUpperCase() + rawWords.substring(1) + " đồng";
    }

    private String formatWords(long number, String[] units) {
        if (number < 0) return "âm " + formatWords(-number, units);
        if (number == 0) return "";
        
        if (number < 10) return units[(int)number];
        if (number < 20) {
            if (number == 10) return "mười";
            if (number == 15) return "mười lăm";
            return "mười " + units[(int)(number % 10)];
        }
        if (number < 100) {
            long chuc = number / 10;
            long dv = number % 10;
            String chucStr = units[(int)chuc] + " mươi";
            if (dv == 1) return chucStr + " mốt";
            if (dv == 5) return chucStr + " lăm";
            if (dv == 0) return chucStr;
            return chucStr + " " + units[(int)dv];
        }
        if (number < 1000) {
            long tram = number / 100;
            long phanDu = number % 100;
            String tramStr = units[(int)tram] + " trăm";
            if (phanDu == 0) return tramStr;
            if (phanDu < 10) return tramStr + " lẻ " + formatWords(phanDu, units);
            return tramStr + " " + formatWords(phanDu, units);
        }
        if (number < 1000000) {
            long nghin = number / 1000;
            long phanDu = number % 1000;
            String nghinStr = formatWords(nghin, units) + " nghìn";
            if (phanDu == 0) return nghinStr;
            if (phanDu < 100) {
                if (phanDu < 10) return nghinStr + " không trăm lẻ " + formatWords(phanDu, units);
                return nghinStr + " không trăm " + formatWords(phanDu, units);
            }
            return nghinStr + " " + formatWords(phanDu, units);
        }
        if (number < 1000000000L) {
            long trieu = number / 1000000;
            long phanDu = number % 1000000;
            String trieuStr = formatWords(trieu, units) + " triệu";
            if (phanDu == 0) return trieuStr;
            if (phanDu < 100000) {
                if (phanDu < 10) return trieuStr + " không trăm lẻ " + formatWords(phanDu, units);
                return trieuStr + " không nghìn " + formatWords(phanDu, units);
            }
            return trieuStr + " " + formatWords(phanDu, units);
        }
        
        long ty = number / 1000000000L;
        long phanDu = number % 1000000000L;
        String tyStr = formatWords(ty, units) + " tỷ";
        if (phanDu == 0) return tyStr;
        return tyStr + " " + formatWords(phanDu, units);
    }

    private String cleanNumberString(String value) {
        if (value == null) {
            return "0";
        }
        String cleaned = value.replaceAll("[,.\\s]", "");
        return cleaned.isEmpty() ? "0" : cleaned;
    }
}
