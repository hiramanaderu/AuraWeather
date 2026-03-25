#include <iostream>
#include <vector>
#include <string>
#include <algorithm>
#include <cmath>
#include <cctype>
#include <set>
#include <unordered_set>
#include <unordered_map>

using namespace std;

const double EPS = 1e-8;
enum Op { ADD, SUB, MUL, DIV };
const string opStr[] = { "+", "-", "×", "÷" };
vector<vector<Op>> opCombinations;

// 预生成有效运算符组合
void pregenOpCombinations() {
    const vector<Op> validOps = {ADD, SUB, MUL, DIV};
    for (Op o1 : validOps) {
        for (Op o2 : validOps) {
            if (o1 == DIV && o2 == DIV) continue;
            for (Op o3 : validOps) {
                if (o1 == SUB && o2 == SUB && o3 == SUB) continue;
                opCombinations.push_back({o1, o2, o3});
            }
        }
    }
}

// 数值+表达式结构体
struct ValExpr {
    double val;
    string expr;
    ValExpr(double v, string e) : val(v), expr(e) {}
    bool operator==(const ValExpr& other) const {
        return fabs(val - other.val) < EPS;
    }
};

namespace std {
    template<> struct hash<ValExpr> {
        size_t operator()(const ValExpr& ve) const {
            return hash<int>()(static_cast<int>(round(ve.val * 1000)));
        }
    };
}

// 工具函数：将数字转为整数字符串（适配牌面显示）
string numToString(double num) {
    int n = static_cast<int>(num);
    if (n == 1) return "A";
    if (n == 11) return "J";
    if (n == 12) return "Q";
    if (n == 13) return "K";
    return to_string(n);
}

// 执行运算（处理除法除零）
bool calc(double a, double b, Op op, double& res) {
    switch (op) {
        case ADD: res = a + b; return true;
        case SUB: res = a - b; return true;
        case MUL: res = a * b; return true;
        case DIV:
            if (fabs(b) < EPS) return false; // 除零保护
            res = a / b; 
            return true;
        default: return false;
    }
}

// 生成表达式（自动加括号保证优先级）
string genExpr(const string& a, Op op, const string& b) {
    return "(" + a + opStr[op] + b + ")";
}

// 分治递归核心
unordered_set<ValExpr> dfs(vector<double>& nums, int l, int r) {
    unordered_set<ValExpr> res;
    // 递归终止：单个数字
    if (l == r) {
        res.emplace(nums[l], numToString(nums[l]));
        return res;
    }
    // 拆分两组：[l..k] 和 [k+1..r]
    for (int k = l; k < r; k++) {
        auto left = dfs(nums, l, k);
        auto right = dfs(nums, k+1, r);
        // 组合两组的所有可能运算
        for (auto& lv : left) {
            for (auto& rv : right) {
                double tmp;
                // 加法
                if (calc(lv.val, rv.val, ADD, tmp)) {
                    res.emplace(tmp, genExpr(lv.expr, ADD, rv.expr));
                }
                // 减法（左-右）
                if (calc(lv.val, rv.val, SUB, tmp)) {
                    res.emplace(tmp, genExpr(lv.expr, SUB, rv.expr));
                }
                // 乘法
                if (calc(lv.val, rv.val, MUL, tmp)) {
                    res.emplace(tmp, genExpr(lv.expr, MUL, rv.expr));
                }
                // 除法（左/右，除零保护）
                if (calc(lv.val, rv.val, DIV, tmp)) {
                    res.emplace(tmp, genExpr(lv.expr, DIV, rv.expr));
                }
            }
        }
    }
    return res;
}

// 转换牌面/数字到数值（恢复完整实现）
bool inputToNum(const string& inputStr, double& num) {
    string s = inputStr;
    for (char& c : s) c = toupper(c);
    // 处理字母牌面
    if (s == "A") { num = 1; return true; }
    else if (s == "J") { num = 11; return true; }
    else if (s == "Q") { num = 12; return true; }
    else if (s == "K") { num = 13; return true; }
    // 处理数字字符串（修复all_of+isdigit的类型问题）
    else if (all_of(s.begin(), s.end(), [](char c) {
        return isdigit(static_cast<unsigned char>(c)) != 0;
    })) {
        num = stod(s);
        // 检查是否为整数
        if (num != floor(num)) {
            cout << "警告：输入的数字\"" << inputStr << "\"不是整数，将取整为" << floor(num) << endl;
            num = floor(num);
        }
        // 检查是否超出扑克牌范围（1-13）
        if (num < 1 || num > 13) {
            char choice;
            cout << "提示：数字" << num << "超出扑克牌面范围（1-13），是否继续使用该数字？(Y/N)：";
            cin >> choice;
            cin.ignore(numeric_limits<streamsize>::max(), '\n'); // 清空输入缓冲区，避免残留
            if (toupper(choice) != 'Y') {
                return false;
            }
        }
        return true;
    }
    // 无效输入
    else {
        cout << "错误：输入\"" << inputStr << "\"不是合法的数字或牌面（A/J/Q/K）！" << endl;
        return false;
    }
}

// 读取并处理4个输入数字（恢复完整实现）
bool readNumbers(vector<double>& nums) {
    nums.clear();
    string input;
    cout << "请输入4个数字/牌面（用空格分隔，支持A=1、J=11、Q=12、K=13）：";
    getline(cin, input);
    // 分割输入
    vector<string> tokens;
    string token;
    for (char c : input) {
        if (isspace(static_cast<unsigned char>(c))) { // 修复isspace类型问题
            if (!token.empty()) {
                tokens.push_back(token);
                token.clear();
            }
        } else {
            token += c;
        }
    }
    if (!token.empty()) tokens.push_back(token);
    // 检查数量
    if (tokens.size() != 4) {
        cout << "错误：请输入恰好4个数字/牌面！" << endl;
        return false;
    }
    // 转换每个输入
    for (const string& t : tokens) {
        double num;
        if (!inputToNum(t, num)) {
            return false;
        }
        nums.push_back(num);
    }
    return true;
}

// 查找24点（修复排列去重逻辑）
bool find24(vector<double>& nums, set<string>& solutions) {
    sort(nums.begin(), nums.end());
    vector<double> lastPerm; // 记录上一轮排列，避免重复
    do {
        // 跳过重复排列（关键：解决重复数字的无效遍历）
        if (nums == lastPerm) continue;
        lastPerm = nums;
        
        auto allRes = dfs(nums, 0, 3);
        for (auto& ve : allRes) {
            if (fabs(ve.val - 24) < EPS) {
                solutions.insert(ve.expr);
            }
        }
    } while (next_permutation(nums.begin(), nums.end()));
    return !solutions.empty();
}

int main() {
    // 解决VS等编译器的numeric_limits报错
    ios::sync_with_stdio(false);
    cin.tie(nullptr);
    
    pregenOpCombinations(); // 预生成运算符组合
    vector<double> nums;
    
    // 读取输入（修复死循环：readNumbers返回true时退出循环）
    while (true) {
        if (readNumbers(nums)) {
            break;
        }
        cout << "请重新输入！" << endl;
    }
    
    // 打印输入的数字（还原牌面）
    cout << "\n输入的数字/牌面为：";
    for (double n : nums) cout << numToString(n) << " ";
    cout << endl;

    // 查找24点解法
    set<string> solutions;
    bool hasSolution = find24(nums, solutions);

    // 输出结果
    if (hasSolution) {
        cout << "\n找到以下解法（去重后）：" << endl;
        int idx = 1;
        for (const string& expr : solutions) {
            cout << idx++ << ". " << expr << " = 24" << endl;
        }
    } else {
        cout << "\n抱歉，无法用这4个数字算出24！" << endl;
    }

    return 0;
}