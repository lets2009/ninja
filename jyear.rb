# coding: sjis

#	jyear.rb $Revision: 1.1 $
#	
#	�����a��ɕϊ�����v���O�C���B
#	���L��c�b�R�~�̓��t�t�H�[�}�b�g�Ŏg���B
#	�u%Y�v�Łu2005�v�̂Ƃ�����A�u%K�v�Łu����17�v�ƕ\���B
#	plugin�ɓ���邾���œ��삷��B
#	
# Copyright (c) 2005 sasasin/SuzukiShinnosuke<sasasin@sasasin.sytes.net>
# You can distribute this file under the GPL.
#

unless Time::new.respond_to?( :strftime_jyear_backup ) then
	eval( <<-MODIFY_CLASS, TOPLEVEL_BINDING )
		class Time
			alias strftime_jyear_backup strftime
			def strftime( format )
				case self.year
					when 0 .. 1926
						gengo = "�́X"
						if self.year == 1926 && self.month == 12 && self.day >=25 then
							gengo = "���a���N"
						end
					when 1927 .. 1989
						jyear = self.year - 1925
						gengo = "���a" + jyear.to_s
						if self.year == 1989 && self.month == 1 && self.day >= 8 then
							gengo = "�������N"
						end
					else
						jyear = self.year - 1988
						gengo = "����" + jyear.to_s
				end
				strftime_jyear_backup( format.gsub( /%K/, gengo ) )
			end
		end
	MODIFY_CLASS
end

