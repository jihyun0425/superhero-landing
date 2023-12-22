package com.member;

import com.board.BoardDAO;
import com.board.BoardDTO;
import com.shop.OrderDAO;
import com.shop.OrderDTO;
import com.util.Alert;
import com.util.LookUp;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import javax.swing.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Optional;

@WebServlet("/member/mypage.do")
public class MypageController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = Optional.ofNullable(req.getParameter("action"))
                .filter(s -> !s.isEmpty())
                .orElse("null");
        int pid = LookUp.getAuth(req, resp);
        switch (action) {
            case "Order" -> {
                OrderDAO dao = new OrderDAO();
                List<OrderDTO> orderList = dao.selectOrderList(String.valueOf(pid));
                dao.close();
                req.setAttribute("orderList", orderList);
                req.getRequestDispatcher("/member/OrderMypage.jsp").forward(req, resp);
            }


            case "QnA" -> {
                BoardDAO dao = new BoardDAO();
                List<BoardDTO> bbs = dao.selectListById("2", String.valueOf(pid));
                dao.close();
                req.setAttribute("bbs", bbs);
                req.getRequestDispatcher("/member/MyQnA.jsp").forward(req, resp);
            }

            case "Review" -> {
                BoardDAO dao = new BoardDAO();
                List<BoardDTO> bbs = dao.selectListById("1", String.valueOf(pid));
                dao.close();
                req.setAttribute("bbs", bbs);
                req.getRequestDispatcher("/member/MyReview.jsp").forward(req, resp);
            }

            case "Shopping" -> req.getRequestDispatcher("/member/MyShoppingCart.jsp").forward(req, resp);

            default -> {
                resp.setContentType("text/html;charset=UTF-8");
                PrintWriter out = resp.getWriter();
                Alert.alertLocation("잘못된 접근입니다.", "/index.do", out);
            }
        }
    }
}
