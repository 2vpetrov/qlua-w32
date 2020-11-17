w32 = require("w32")

-- ���������� handle �������� ���� QUIK ��� 0 ��� ������
-- ���� �������� ��������� ���������� - ���������� ��� QUIK, �� �������� ������� ��� ������
function GetQuikMainWindowHandle()
	local hQuikWnd = 0
	while true do
		hQuikWnd = w32.FindWindowEx(0, hQuikWnd, "InfoClass", "")
		if hQuikWnd == 0 then
			break
		end
		local t,WinProcId = w32.GetWindowThreadProcessId(hQuikWnd)
		if WinProcId == w32.GetCurrentProcessId() then
			break
		end
	end

	return hQuikWnd
end

-- ������� �������� ������� �������� ���� � ��������
function CreateTableWindow(caption)
	local t_id = AllocTable()   
	AddColumn(t_id, 0, "1", true, QTABLE_INT_TYPE, 15)
	AddColumn(t_id, 1, "2", true, QTABLE_INT_TYPE, 15)
	local t = CreateWindow(t_id)
	SetWindowCaption(t_id, caption)
	InsertRow(t_id, -1)
	SetCell(t_id, 1, 1, "<<" .. caption .. ">>")
end

-- �������� ���

hQuikWnd = GetQuikMainWindowHandle()

hTabWnd = 0  -- ����� ����� handle ���� �������

if hQuikWnd > 0 then
	hTabWnd = w32.FindWindowEx(hQuikWnd, 0, "SysTabControl32", "")
	if hTabWnd ~= 0 and not w32.IsWindowVisible(hTabWnd) then
		-- ���� ���� ������� �������, �� ����������� ������� ��������� - ������� � 0
		hTabWnd = 0
	end
end

if hTabWnd > 0 then
	-- ���� ������� � ��������� ������������
	-- �������� ������ ������� �������� �������
	local prevIdx = w32.TabCtrl_GetCurFocus(hTabWnd)

	-- ������� ������ ������� � ������ "�������"
	local idxGr = w32.TabCtrl_GetItemIndexByText(hTabWnd, "�������")
	if idxGr >= 0 then
		-- ���� ������� "�������" �������
		-- ������������ �� �� � �������� ������� �� ���
		w32.TabCtrl_SetCurFocus(hTabWnd, idxGr)
		CreateTableWindow("������� '�������'")
	end

	-- ������� ����� ���������� �������
	cnt = w32.TabCtrl_GetItemCount(hTabWnd)
	for i = 0, cnt-1 do
		-- ������������� ���������� �� ������ ������� � ������� ������� � ������ �������
		w32.TabCtrl_SetCurFocus(hTabWnd, i)
		-- ������� �������� �������
		-- �.�. �������� �������� ������� �������� ������� (������ ��� �� ��� �������������),
		-- �� ������ �������� ����� �� ���������
		local txt = w32.TabCtrl_GetItemText(hTabWnd, i)
		CreateTableWindow(txt)
	end

	-- ������������ ����� �� �������� �������
	w32.TabCtrl_SetCurFocus(hTabWnd, prevIdx)
else
	-- ���� ������� � ��������� �� ������������
	CreateTableWindow("������� ���������")
end
